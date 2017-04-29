module Polyfill
  module InternalUtils
    VERSIONS = {
      '2.2' => 'V2_2',
      '2.3' => 'V2_3',
      '2.4' => 'V2_4'
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
  end
end
