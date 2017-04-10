module Polyfill
  module V2_4
    module IPAddr
      def ==(*)
        super
      rescue
        false
      end

      def <=>(*)
        super
      rescue
        nil
      end
    end
  end
end
