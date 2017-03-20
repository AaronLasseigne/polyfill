require 'English'

module Polyfill
  module V2_4
    module IO
      module Class
        module Foreach
          module Method
            def foreach(name, *args)
              hash, others = args.partition { |arg| arg.is_a?(::Hash) }
              chomps = hash[0] && hash[0][:chomp]

              unless block_given?
                return super(name, *others) unless chomps

                separator = others.find do |other|
                  other.respond_to?(:to_str)
                end || $INPUT_RECORD_SEPARATOR

                return Enumerator.new do |yielder|
                  super(name, *others) do |line|
                    yielder.yield(line.chomp(separator))
                  end
                end
              end

              block =
                if chomps
                  separator = others.find do |other|
                    other.respond_to?(:to_str)
                  end || $INPUT_RECORD_SEPARATOR

                  proc do |line|
                    yield(line.chomp(separator))
                  end
                else
                  Proc.new
                end

              super(name, *others, &block)
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::IO.singleton_class do
              include Method
            end

            def self.included(base)
              base.include Method
            end
          end
        end
      end
    end
  end
end
