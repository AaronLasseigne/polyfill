module Polyfill
  module V2_4
    module Regexp
      def match?(string, position = 0)
        !!(string[position..-1] =~ self) # rubocop:disable Style/InverseMethods
      end
    end
  end
end
