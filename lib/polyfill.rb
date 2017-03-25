require 'polyfill/version'
require 'polyfill/utils'
require 'polyfill/v2_3'
require 'polyfill/v2_4'

module Polyfill
  include V2_3
  include V2_4
end

def Polyfill(options) # rubocop:disable Style/MethodName
  mod = Module.new

  objects, others = options.partition { |key,| key[/\A[A-Z]/] }

  unless others.empty?
    raise ArgumentError, "unknown keyword: #{others.first[0]}"
  end

  current_ruby_version = RUBY_VERSION[/\A(\d+\.\d+)/, 1]
  versions = {
    '2.3' => Polyfill::V2_3,
    '2.4' => Polyfill::V2_4
  }

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

    if methods == :all
      mod.module_eval do
        object_modules.each do |(version_number, object_module)|
          include object_module if version_number > current_ruby_version
        end
      end
    else
      methods.each do |method|
        type =
          case method[0]
          when '.'
            :Class
          when '#'
            :Instance
          else
            raise ArgumentError, %Q("#{method}" must start with a "." if it's a class method or "#" if it's an instance method)
          end

        method_name = method[1..-1]
        symbol_conversions = {
          '=' => 'equal',
          '<' => 'lessthan',
          '>' => 'greaterthan',
          '?' => '_q',
          '!' => '_e'
        }
        method_name.gsub!(/[#{symbol_conversions.keys.join}]/o, symbol_conversions)
        method_name.capitalize!
        method_name.gsub!(/_(.)/) { |match| match[1].capitalize }

        method_modules = object_modules
          .map do |(version_number, object_module)|
            begin
              [version_number, object_module.const_get(type, false).const_get(method_name, false)]
            rescue NameError
              nil
            end
          end
          .compact

        if method_modules.empty?
          raise ArgumentError, %Q("#{method}" is not a valid method on #{full_name} or has no updates)
        end

        mod.module_eval do
          method_modules.each do |(version_number, method_module)|
            include method_module if version_number > current_ruby_version
          end
        end
      end
    end
  end

  mod
end
