module Polyfill
  module V2_3
    module Enumerable
      def chunk_while
        block = ::Proc.new

        enum_count =
          begin
            size
          rescue NameError
            count
          end

        return [self] if enum_count == 1

        ::Enumerator.new do |yielder|
          output = []
          each_cons(2).with_index(1) do |(a, b), run|
            if run == enum_count - 1
              if block.call(a, b)
                output.push(a, b)
                yielder << output
              else
                output.push(a)
                yielder << output
                yielder << [b]
              end
            else
              output.push(a)
              unless block.call(a, b)
                yielder << output
                output = []
              end
            end
          end
        end
      end

      def grep_v(pattern)
        output = to_a - grep(pattern)
        output.map!(&::Proc.new) if block_given?
        output
      end

      def slice_before(*args)
        if !args.empty? && block_given?
          raise ArgumentError, 'wrong number of arguments (given 1, expected 0)'
        end

        super
      end
    end
  end
end
