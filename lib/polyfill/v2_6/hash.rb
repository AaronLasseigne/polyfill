module Polyfill
  module V2_6
    module Hash
      def merge(*args)
        if block_given?
          block = ::Proc.new

          args.each_with_object(dup) do |arg, h|
            h.merge!(arg, &block)
          end
        else
          args.each_with_object(dup) do |arg, h|
            h.merge!(arg)
          end
        end
      end
    end
  end
end
