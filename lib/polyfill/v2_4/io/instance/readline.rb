module Polyfill
  module V2_4
    module IO
      module Instance
        module Readline
          module Method
            def readline(*args)
              hash, others = args.partition { |arg| arg.is_a?(::Hash) }

              input = super(*others)

              if hash[0] && hash[0][:chomp]
                separator = others.find do |other|
                  other.respond_to?(:to_str)
                end || $/

                input.chomp!(separator)
              end

              input
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
