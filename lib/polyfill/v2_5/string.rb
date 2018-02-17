module Polyfill
  module V2_5
    module String
      def delete_prefix(prefix)
        sub(/\A#{prefix.to_str}/, ''.freeze)
      end

      def delete_suffix(suffix)
        chomp(suffix)
      end

      def start_with?(*prefixes)
        super if prefixes.grep(Regexp).empty?

        prefixes.any? do |prefix|
          prefix.is_a?(Regexp) ? self[/\A#{prefix}/] : super(prefix)
        end
      end
    end
  end
end
