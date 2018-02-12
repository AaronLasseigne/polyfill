module Polyfill
  module V2_5
    module Integer
      using Polyfill(Integer: %w[#ceil #floor #round #truncate], version: '2.4')

      def ceil(*)
        super.to_i
      end

      def floor(*)
        super.to_i
      end

      def round(*)
        super.to_i
      end

      def truncate(*)
        super.to_i
      end

      def allbits?(mask)
        unless mask.respond_to?(:to_int)
          raise TypeError, "no explicit conversion of #{mask.class} to Integer"
        end

        imask = mask.to_int
        self & imask == imask
      end
    end
  end
end
