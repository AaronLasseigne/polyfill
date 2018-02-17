module Polyfill
  module V2_5
    module String
      def casecmp(other_str)
        super
      rescue TypeError
        nil
      end

      def casecmp?(other_str)
        super
      rescue TypeError
        nil
      end

      def delete_prefix(prefix)
        sub(/\A#{prefix.to_str}/, ''.freeze)
      rescue NoMethodError
        raise TypeError, "no implicit conversion of #{prefix.class} into String"
      end

      def delete_prefix!(prefix)
        prev = dup
        current = sub!(/\A#{prefix.to_str}/, ''.freeze)
        prev == current ? nil : current
      rescue NoMethodError
        raise TypeError, "no implicit conversion of #{prefix.class} into String"
      end

      def delete_suffix(suffix)
        chomp(suffix)
      end

      def delete_suffix!(suffix)
        chomp!(suffix)
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
