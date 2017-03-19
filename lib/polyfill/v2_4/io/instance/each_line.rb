module Polyfill
  module V2_4
    module IO
      module Instance
        module EachLine
          module Method
            def each_line(*args)
              hash, others = args.partition { |arg| arg.is_a?(::Hash) }

              chomps = hash[0] && hash[0][:chomp]

              unless block_given?
                if chomps
                  separator = others.find { |other| other.respond_to?(:to_str) }

                  return Enumerator.new do |yielder|
                    block =
                      if separator
                        Proc.new do |line|
                          yielder.yield(line.chomp(separator))
                        end
                      else
                        Proc.new do |line|
                          yielder.yield(line.chomp)
                        end
                      end
                    super(*others, &block)
                  end
                else
                  return super(*others)
                end
              end

              block =
                if chomps
                  separator = others.find { |other| other.respond_to?(:to_str) }
                  if separator
                    Proc.new do |line|
                      yield(line.chomp(separator))
                    end
                  else
                    Proc.new do |line|
                      yield(line.chomp)
                    end
                  end
                else
                  Proc.new
                end

              super(*others, &block)
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::IO do
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
