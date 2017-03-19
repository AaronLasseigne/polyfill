module Polyfill
  module V2_4
    module String
      module Instance
        module Lines
          module Method
            def lines(*args)
              hash, others = args.partition { |arg| arg.is_a?(::Hash) }
              chomps = hash[0] && hash[0][:chomp]

              unless block_given?
                lines = super(*others)

                if chomps
                  separator = others.find do |other|
                    other.respond_to?(:to_str)
                  end || $/

                  lines.each { |line| line.chomp!(separator) }
                end

                return lines
              end

              block =
                if chomps
                  separator = others.find do |other|
                    other.respond_to?(:to_str)
                  end || $/

                  Proc.new do |line|
                    yield(line.chomp(separator))
                  end
                else
                  Proc.new
                end

              super(*others, &block)
            end
          end

          if RUBY_VERSION < '2.4.0'
            refine ::String do
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
