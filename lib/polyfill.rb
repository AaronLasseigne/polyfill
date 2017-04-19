require 'ipaddr'
require 'stringio'
require 'polyfill/version'
require 'polyfill/utils'

module Polyfill
  module Parcel; end
end

def Polyfill(options = {}) # rubocop:disable Style/MethodName
  mod = Module.new

  #
  # parse options
  #
  objects, others = options.partition { |key,| key[/\A[A-Z]/] }
  others = others.to_h

  versions = {
    '2.2' => Polyfill::V2_2,
    '2.3' => Polyfill::V2_3,
    '2.4' => Polyfill::V2_4
  }
  desired_version = others.delete(:version) || versions.keys.max
  unless versions.keys.include?(desired_version)
    raise ArgumentError, "invalid value for keyword version: #{desired_version}"
  end
  versions.reject! do |version_number, _|
    version_number > desired_version
  end

  native = others.delete(:native) { false }

  unless others.empty?
    raise ArgumentError, "unknown keyword: #{others.first[0]}"
  end

  # if no objects are given we need them all
  if objects.empty?
    objects = versions.each_with_object({}) do |(_, version_module), acc|
      version_module.constants(false).each do |obj_name|
        acc[obj_name] = :all
      end
    end
  end

  #
  # useful vars
  #
  current_ruby_version = RUBY_VERSION[/\A(\d+\.\d+)/, 1]
  all_instance_modules = []

  objects.each do |full_name, methods|
    #
    # find all polyfills for the object across all versions
    #
    object_module_names = full_name.to_s.split('::')

    object_modules = versions
      .map do |version_number, version_module|
        begin
          final_module = object_module_names
            .reduce(version_module) do |current_mod, name|
              current_mod.const_get(name, false)
            end

          [version_number, final_module]
        rescue NameError
          nil
        end
      end
      .compact

    if object_modules.empty?
      raise ArgumentError, %Q("#{full_name}" is not a valid class or has no updates)
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
      raise ArgumentError, %Q(".#{leftovers.first}" is not a valid method on #{full_name} or has no updates)
    end
    unless (leftovers = (requested_instance_methods - available_instance_methods)).empty?
      raise ArgumentError, %Q("##{leftovers.first}" is not a valid method on #{full_name} or has no updates)
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
      next if version_number <= current_ruby_version

      class_module.instance_methods.each do |name|
        class_module.send(:remove_method, name) unless requested_class_methods.include?(name)
      end

      next if class_module.instance_methods.empty?

      mod.module_exec(requested_class_methods) do |methods_added|
        base_classes.each do |klass|
          refine Object.const_get(klass).singleton_class do
            include class_module

            if native
              Polyfill::Utils.ignore_warnings do
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
      next if version_number <= current_ruby_version

      instance_module.instance_methods.each do |name|
        instance_module.send(:remove_method, name) unless requested_instance_methods.include?(name)
      end

      next if instance_module.instance_methods.empty?

      all_instance_modules << instance_module

      mod.module_exec(requested_instance_methods) do |methods_added|
        base_classes.each do |klass|
          refine Object.const_get(klass) do
            include instance_module

            if native
              Polyfill::Utils.ignore_warnings do
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

  #
  # make sure the includes get added if this module is included
  #
  mod.singleton_class.send(:define_method, :included) do |base|
    all_instance_modules.each do |instance_module|
      base.include instance_module
    end
  end

  Polyfill::Parcel.const_set("O#{mod.object_id}", mod)
end

require 'polyfill/v2_2'
require 'polyfill/v2_3'
require 'polyfill/v2_4'
