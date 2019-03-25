module Polyfill
  module V2_6
    module Kernel
      using Polyfill(Kernel: %w[#yield_self], version: '2.5')

      def Float(arg, exception: true) # rubocop:disable Naming/MethodName
        super(arg) if exception

        begin
          super(arg)
        rescue ArgumentError, TypeError
          nil
        end
      end

      def then
        return yield_self unless block_given?

        yield_self(&::Proc.new)
      end
    end
  end
end
