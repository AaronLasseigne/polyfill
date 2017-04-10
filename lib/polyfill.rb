require 'polyfill/version'
require 'stringio'

module Polyfill
  module Parcel; end
end

def Polyfill(options = {}) # rubocop:disable Style/MethodName
  mod = Module.new

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

  unless others.empty?
    raise ArgumentError, "unknown keyword: #{others.first[0]}"
  end

  current_ruby_version = RUBY_VERSION[/\A(\d+\.\d+)/, 1]
  all_instance_modules = []

  if objects.empty?
    objects = versions.each_with_object({}) do |(_, version_module), acc|
      version_module.constants(false).each do |obj_name|
        acc[obj_name] = :all
      end
    end
  end

  objects.each do |full_name, methods|
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

    if methods != :all && (method_name = methods.find { |method| method !~ /\A[.#]/ })
      raise ArgumentError, %Q("#{method_name}" must start with a "." if it's a class method or "#" if it's an instance method)
    end

    all_methods_for = lambda do |modules|
      modules.flat_map { |_, class_module| class_module.instance_methods }.uniq
    end
    available_class_methods = all_methods_for.call(class_modules)
    available_instance_methods = all_methods_for.call(instance_modules)

    select_and_clean = lambda do |leader|
      methods.select { |method| method.start_with?(leader) }.map { |method| method[1..-1].to_sym }
    end
    class_methods = methods == :all ? available_class_methods : select_and_clean.call('.')
    instance_methods = methods == :all ? available_instance_methods : select_and_clean.call('#')

    unless (leftovers = (class_methods - available_class_methods)).empty?
      raise ArgumentError, %Q(".#{leftovers.first}" is not a valid method on #{full_name} or has no updates)
    end
    unless (leftovers = (instance_methods - available_instance_methods)).empty?
      raise ArgumentError, %Q("##{leftovers.first}" is not a valid method on #{full_name} or has no updates)
    end

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

    class_modules.each do |version_number, class_module|
      next if version_number <= current_ruby_version

      class_module.instance_methods.each do |name|
        class_module.send(:remove_method, name) unless class_methods.include?(name)
      end

      mod.module_eval do
        base_classes.each do |klass|
          refine Object.const_get(klass).singleton_class do
            include class_module
          end
        end
      end
    end

    instance_modules.each do |version_number, instance_module|
      next if version_number <= current_ruby_version

      instance_module.instance_methods.each do |name|
        instance_module.send(:remove_method, name) unless instance_methods.include?(name)
      end

      all_instance_modules << instance_module

      mod.module_eval do
        base_classes.each do |klass|
          refine Object.const_get(klass) do
            include instance_module
          end
        end
      end
    end
  end

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
