RSpec.describe 'Polyfill' do
  context 'using' do
    context 'without arguments' do
      using Polyfill

      it 'adds everything' do
        when_ruby_below '2.4' do
          expect { 1.finite? }.to_not raise_error
          expect { {}.transform_values }.to_not raise_error
        end
      end
    end

    context 'with arguments' do
      it 'errors on invalid keys' do
        expect do
          Polyfill(invalid_key: :all)
        end.to raise_error(ArgumentError, 'unknown keyword: invalid_key')
      end

      context 'capitalized symbols are treated as class names' do
        it 'returns a Module' do
          expect(Polyfill({})).to be_a Module
        end

        context 'passed :all' do
          using Polyfill(Enumerable: :all)

          it 'adds everything for that class' do
            expect { [].chunk }.to_not raise_error # added v2.4
            expect { [].chunk_while {} }.to_not raise_error # added v2.3
          end
        end

        context 'passed an array of strings' do
          context 'for requested methods' do
            using Polyfill(
              Dir: %w[.empty?],
              Enumerable: %w[#chunk_while],
              Hash: %w[#compact #compact!]
            )

            it 'adds the particular methods requested for that class' do
              expect { {}.compact }.to_not raise_error
              expect { {}.compact! }.to_not raise_error
              when_ruby_below '2.4' do
                expect { Dir.empty?('directory') }.to_not raise_error
              end
              expect { [].chunk_while {} }.to_not raise_error
            end

            it 'does not add methods that were not requested' do
              when_ruby_below '2.4' do
                expect { {}.transform_values }.to raise_error(NoMethodError)
              end
            end
          end

          it 'fails on invalid classes' do
            expect do
              Polyfill(ThisIsNotARealClass: :all)
            end.to raise_error(ArgumentError, '"ThisIsNotARealClass" is not a valid class or has no updates')

            expect do
              Polyfill('ThisIsNotA::RealClass': :all)
            end.to raise_error(ArgumentError, '"ThisIsNotA::RealClass" is not a valid class or has no updates')
          end

          it 'fails on methods missing a starting "." or "#"' do
            expect do
              Polyfill(String: %w[ambiguous_method])
            end.to raise_error(ArgumentError, %q("ambiguous_method" must start with a "." if it's a class method or "#" if it's an instance method))
          end

          it 'fails on invalid methods' do
            expect do
              Polyfill(String: %w[#this_is_not_a_method])
            end.to raise_error(ArgumentError, '"#this_is_not_a_method" is not a valid method on String or has no updates')
          end
        end
      end
    end
  end

  context 'include' do
    it 'can include everything (please do not do this)' do
      klass = Class.new do
        include Polyfill
      end

      when_ruby_below '2.4' do
        # expect(klass.respond_to?(:empty?)).to be true
        expect(klass.new.respond_to?(:finite?)).to be true
        expect(klass.new.respond_to?(:clamp)).to be true
      end
    end

    it 'can include everything for a class' do
      klass = Class.new(Numeric) do
        include Polyfill(Numeric: :all)
      end

      expect(klass.new.respond_to?(:finite?)).to be true
      expect(klass.new.respond_to?(:infinite?)).to be true
    end

    it 'can include particular methods for a class' do
      klass = Class.new(Numeric) do
        include Polyfill(Numeric: %w[#finite?])
      end

      expect(klass.new.respond_to?(:finite?)).to be true
      when_ruby_below '2.4' do
        expect(klass.new.respond_to?(:infinite?)).to be false
      end
    end
  end
end
