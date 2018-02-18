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
        imask = InternalUtils.to_int(mask)
        self & imask == imask
      end

      def anybits?(mask)
        self & InternalUtils.to_int(mask) != 0
      end

      def nobits?(mask)
        self & InternalUtils.to_int(mask) == 0
      end
    end
  end
end
