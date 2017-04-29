require 'ipaddr'
require 'stringio'
require 'polyfill/version'
require 'polyfill/internal_utils'

module Polyfill
  module Parcel; end

  def get(module_name, methods, options = {})
    if Object.const_get(module_name.to_s).is_a?(Class)
      raise ArgumentError, "#{module_name} is a class not a module"
    end

    #
    # parse options
    #
    versions = InternalUtils.polyfill_versions_to_use(options.delete(:version))

    unless options.empty?
      raise ArgumentError, "unknown keyword: #{options.first[0]}"
    end

    #
    # find all polyfills for the module across all versions
    #
    modules_with_updates = []
    modules = []
    versions.each do |version_number, version_module|
      begin
        final_module = version_module.const_get(module_name.to_s, false)

        modules_with_updates << final_module

        next if version_number <= InternalUtils.current_ruby_version

        modules << final_module.clone
      rescue NameError
        nil
      end
    end

    if modules_with_updates.empty?
      raise ArgumentError, %Q("#{module_name}" has no updates)
    end

    #
    # remove methods that were not requested
    #
    methods_with_updates = modules_with_updates.flat_map(&:instance_methods).uniq
    requested_methods = methods == :all ? methods_with_updates : methods

    unless (leftovers = (requested_methods - methods_with_updates)).empty?
      raise ArgumentError, %Q("##{leftovers.first}" is not a valid method on #{module_name} or has no updates)
    end

    modules.each do |instance_module|
      InternalUtils.keep_only_these_methods!(instance_module, requested_methods)
    end

    #
    # build the module to return
    #
    mod = Module.new

    # make sure the methods get added if this module is included
    mod.singleton_class.send(:define_method, :included) do |base|
      modules.each do |module_to_add|
        base.include module_to_add unless module_to_add.instance_methods.empty?
      end
    end

    # make sure the methods get added if this module is extended
    mod.singleton_class.send(:define_method, :extended) do |base|
      modules.each do |module_to_add|
        base.extend module_to_add unless module_to_add.instance_methods.empty?
      end
    end

    Polyfill::Parcel.const_set("O#{mod.object_id}", mod)
  end
  module_function :get
end

def Polyfill(options = {}) # rubocop:disable Style/MethodName
  mod = Module.new

  #
  # parse options
  #
  objects, others = options.partition { |key,| key[/\A[A-Z]/] }
  objects.sort! do |a, b|
    if !a.is_a?(Class) && b.is_a?(Class)
      -1
    elsif a.is_a?(Class) && !b.is_a?(Class)
      1
    else
      0
    end
  end
  others = others.to_h

  versions = Polyfill::InternalUtils.polyfill_versions_to_use(others.delete(:version))
  native = others.delete(:native) { false }

  unless others.empty?
    raise ArgumentError, "unknown keyword: #{others.first[0]}"
  end

  objects.each do |module_name, methods|
    #
    # find all polyfills for the object across all versions
    #
    object_modules = versions
      .map do |version_number, version_module|
        begin
          final_module = version_module.const_get(module_name.to_s, false)

          [version_number, final_module]
        rescue NameError
          nil
        end
      end
      .compact

    if object_modules.empty?
      raise ArgumentError, %Q("#{module_name}" is not a valid object or has no updates)
    end

    #
    # get all class modules and instance modules from the polyfills
    #
    class_modules = object_modules.map do |version_number, object_module|
      begin
        [version_number, object_module.const_get(:ClassMethods, false).clone]
      rescue NameError
        nil
      end
    end.compact
    instance_modules = object_modules.map do |version_number, object_module|
      [version_number, object_module.clone]
    end

    #
    # get all requested class and instance methods
    #
    if methods != :all && (method_name = methods.find { |method| method !~ /\A[.#]/ })
      raise ArgumentError, %Q("#{method_name}" must start with a "." if it's a class method or "#" if it's an instance method)
    end

    all_methods_for = lambda do |modules|
      modules.flat_map { |_, m| m.instance_methods }.uniq
    end
    available_class_methods = all_methods_for.call(class_modules)
    available_instance_methods = all_methods_for.call(instance_modules)

    select_and_clean = lambda do |leader|
      methods.select { |method| method.start_with?(leader) }.map { |method| method[1..-1].to_sym }
    end
    requested_class_methods = methods == :all ? available_class_methods : select_and_clean.call('.')
    requested_instance_methods = methods == :all ? available_instance_methods : select_and_clean.call('#')

    unless (leftovers = (requested_class_methods - available_class_methods)).empty?
      raise ArgumentError, %Q(".#{leftovers.first}" is not a valid method on #{module_name} or has no updates)
    end
    unless (leftovers = (requested_instance_methods - available_instance_methods)).empty?
      raise ArgumentError, %Q("##{leftovers.first}" is not a valid method on #{module_name} or has no updates)
    end

    #
    # get the class(es) to refine
    #
    base_class = object_modules.first.last.name.sub(/\APolyfill::V\d_\d::/, '')
    base_classes =
      case base_class
      when 'Comparable'
        %w[Numeric String Time]
      when 'Enumerable'
        %w[Array Dir Enumerator Hash IO Range StringIO Struct]
      when 'Kernel'
        %w[Object]
      else
        [base_class]
      end

    #
    # refine in class methods
    #
    class_modules.each do |version_number, class_module|
      next if version_number <= Polyfill::InternalUtils.current_ruby_version

      Polyfill::InternalUtils.keep_only_these_methods!(class_module, requested_class_methods)

      next if class_module.instance_methods.empty?

      mod.module_exec(requested_class_methods) do |methods_added|
        base_classes.each do |klass|
          refine Object.const_get(klass).singleton_class do
            include class_module

            if native
              Polyfill::InternalUtils.ignore_warnings do
                define_method :respond_to? do |name, include_all = false|
                  return true if methods_added.include?(name)

                  super(name, include_all)
                end

                define_method :__send__ do |name, *args, &block|
                  return super(name, *args, &block) unless methods_added.include?(name)

                  class_module.instance_method(name).bind(self).call(*args, &block)
                end
                alias_method :send, :__send__
              end
            end
          end
        end
      end
    end

    #
    # refine in instance methods
    #
    instance_modules.each do |version_number, instance_module|
      next if version_number <= Polyfill::InternalUtils.current_ruby_version

      Polyfill::InternalUtils.keep_only_these_methods!(instance_module, requested_instance_methods)

      next if instance_module.instance_methods.empty?

      mod.module_exec(requested_instance_methods) do |methods_added|
        base_classes.each do |klass|
          refine Object.const_get(klass) do
            include instance_module

            if native
              Polyfill::InternalUtils.ignore_warnings do
                define_method :respond_to? do |name, include_all = false|
                  return super(name, include_all) unless methods_added.include?(name)

                  true
                end

                define_method :__send__ do |name, *args, &block|
                  return super(name, *args, &block) unless methods_added.include?(name)

                  instance_module.instance_method(name).bind(self).call(*args, &block)
                end
                alias_method :send, :__send__
              end
            end
          end
        end
      end
    end
  end

  Polyfill::Parcel.const_set("O#{mod.object_id}", mod)
end

require 'polyfill/v2_2'
require 'polyfill/v2_3'
require 'polyfill/v2_4'
