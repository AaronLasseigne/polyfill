module Polyfill
  module Utils
    def when_ruby_below(version)
      yield if RUBY_VERSION[/\A(\d+\.\d+)/, 1] < version
    end
    module_function :when_ruby_below
  end
end
