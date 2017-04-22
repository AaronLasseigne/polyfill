module Polyfill
  module V2_2
    module Enumerable
      def slice_after(pattern = nil)
        raise ArgumentError, 'both pattern and block are given' if pattern && block_given?
        raise ArgumentError, 'wrong number of arguments (given 0, expected 1)' if !pattern && !block_given?

        matcher = pattern || ::Proc.new
        enum_count =
          begin
            size
          rescue NameError
            count
          end

        ::Enumerator.new do |yielder|
          output = []
          run = 1
          each do |element, *rest|
            elements = rest.any? ? [element, *rest] : element

            output.push(elements)
            if matcher === elements || run == enum_count # rubocop:disable Style/CaseEquality
              yielder << output
              output = []
            end

            run += 1
          end
        end
      end

      def slice_when
        block = ::Proc.new

        ::Enumerator.new do |yielder|
          output = []
          each do |element, *rest|
            elements = rest.any? ? [element, *rest] : element

            if output.empty? || !block.call(output.last, elements)
              output.push(elements)
            else
              yielder << output
              output = [elements]
            end
          end
          yielder << output unless output.empty?
        end
      end
    end
  end
end
