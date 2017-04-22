module Polyfill
  module V2_2
    module Enumerable
      def slice_after(pattern = nil)
        raise ArgumentError, 'both pattern and block are given' if pattern && block_given?
        raise ArgumentError, 'wrong number of arguments (given 0, expected 1)' if !pattern && !block_given?

        matcher = pattern || ::Proc.new

        ::Enumerator.new do |yielder|
          output = []
          run = 1
          each do |element, *rest|
            elements = rest.any? ? [element, *rest] : element

            output.push(elements)
            if matcher === elements || run == count # rubocop:disable Style/CaseEquality
              yielder << output
              output = []
            end

            run += 1
          end
        end
      end
    end
  end
end
