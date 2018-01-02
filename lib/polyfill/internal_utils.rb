module Polyfill
  module InternalUtils
    VERSIONS = {
      '2.2' => 'V2_2',
      '2.3' => 'V2_3',
      '2.4' => 'V2_4',
      '2.5' => 'V2_5'
    }.freeze
    private_constant :VERSIONS

    def current_ruby_version
      @current_ruby_version ||= RUBY_VERSION[/\A(\d+\.\d+)/, 1]
    end
    module_function :current_ruby_version

    def ignore_warnings
      orig = $VERBOSE
      $VERBOSE = nil

      yield

      $VERBOSE = orig
    end
    module_function :ignore_warnings

    def polyfill_versions_to_use(desired_version = nil)
      desired_version = VERSIONS.keys.max if desired_version.nil?

      unless VERSIONS.keys.include?(desired_version)
        raise ArgumentError, "invalid value for keyword version: #{desired_version}"
      end

      VERSIONS
        .reject { |version, _| version > desired_version }
        .map { |version, mod| [version, Polyfill.const_get(mod, false)] }
        .to_h
    end
    module_function :polyfill_versions_to_use

    def keep_only_these_methods!(mod, whitelist)
      mod.instance_methods.each do |name|
        mod.send(:remove_method, name) unless whitelist.include?(name)
      end
    end
    module_function :keep_only_these_methods!

    def modules_to_use(module_name, versions)
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

      [modules_with_updates, modules]
    end
    module_function :modules_to_use

    def methods_to_keep(modules, methods, lead_symbol, module_name)
      methods_with_updates = modules.flat_map(&:instance_methods).uniq
      requested_methods = methods == :all ? methods_with_updates : methods

      unless (leftovers = (requested_methods - methods_with_updates)).empty?
        raise ArgumentError, %Q("#{lead_symbol}#{leftovers.first}" is not a valid method on #{module_name} or has no updates)
      end

      requested_methods
    end
    module_function :methods_to_keep

    def create_module
      mod = ::Module.new

      yield(mod)

      Polyfill::Module.const_set("M#{mod.object_id}", mod)
    end
    module_function :create_module
  end
end
