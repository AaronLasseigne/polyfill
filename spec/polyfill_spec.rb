RSpec.describe 'Polyfill()' do
  context 'using' do
    context 'without arguments' do
      using Polyfill()

      it 'adds nothing' do
        when_ruby_below('2.3') do
          expect { 1.finite? }.to raise_error(NoMethodError)
          expect { {}.transform_values }.to raise_error(NoMethodError)
        end
      end
    end

    context 'with arguments' do
      it 'errors on invalid keys' do
        expect do
          Polyfill(invalid_key: :all)
        end.to raise_error(ArgumentError, 'unknown keyword: invalid_key')
      end

      context ':version' do
        it 'errors on invalid version numbers' do
          expect do
            Polyfill(version: 'invalid', Enumerable: :all)
          end.to raise_error(ArgumentError, 'invalid value for keyword version: invalid')
        end

        context 'with a valid version number' do
          using Polyfill(
            version: '2.3',
            Enumerable: :all
          )

          it 'limits updates to the version given' do
            expect { [].chunk_while {} }.to_not raise_error # added v2.3

            when_ruby_below('2.4') do
              # blockless vesion added v2.4
              expect { [].chunk }.to raise_error(ArgumentError)
            end
          end
        end
      end

      context ':native' do
        context 'is true' do
          using Polyfill(
            native: true,
            Array: %w[#concat #sum],
            File: %w[.empty?]
          )

          context '#respond_to?' do
            it 'works for existing methods' do
              expect([].respond_to?(:size)).to be true
            end

            it 'works for updates' do
              expect([].respond_to?(:concat)).to be true
            end

            it 'works for new methods' do
              expect([].respond_to?(:sum)).to be true
              expect(File.respond_to?(:empty?)).to be true
            end
          end

          context '#__send__' do
            it 'works for existing methods' do
              expect([].__send__(:size)).to eql 0
            end

            it 'works for updates' do
              expect([].__send__(:concat, [1], [2])).to eql [1, 2]
            end

            it 'works for new methods' do
              expect([].__send__(:sum)).to eql 0
              expect(File.__send__(:empty?, '.')).to be false
            end
          end

          context '#send' do
            it 'works for existing methods' do
              expect([].send(:size)).to eql 0
            end

            it 'works for updates' do
              expect([].send(:concat, [1], [2])).to eql [1, 2]
            end

            it 'works for new methods' do
              expect([].send(:sum)).to eql 0
              expect(File.send(:empty?, '.')).to be false
            end
          end
        end

        context 'is false' do
          using Polyfill(
            native: false,
            Array: %w[#concat #sum],
            File: %w[.empty?]
          )

          it 'does not add #respond_to? support' do
            when_ruby_below('2.4') do
              expect([].respond_to?(:sum)).to be false
              expect(File.respond_to?(:empty?)).to be false
            end
          end
        end
      end

      it 'returns the same module across multiple calls with the same arguments' do
        mod1 = Polyfill(Enumerable: :all)
        mod2 = Polyfill(Enumerable: :all)
        expect(mod1).to be mod2
      end

      it 'uses the same module name across multiple ruby invocations' do
        mod1 = `ruby -r./lib/polyfill -e 'puts Polyfill(Enumerable: :all).name'`
        mod2 = `ruby -r./lib/polyfill -e 'puts Polyfill(Enumerable: :all).name'`
        expect(mod1).to eq(mod2)
        expect(mod1).to start_with('Polyfill::Module::')
      end

      it 'returns a different module across multiple calls with the different arguments' do
        mod1 = Polyfill(Enumerable: :all)
        mod2 = Polyfill(Enumerable: %w[#to_h])
        expect(mod1).to_not be mod2
      end

      context 'capitalized symbols are treated as class names' do
        it 'returns a Module named Polyfill::Module::*' do
          mod = Polyfill({})
          expect(mod).to be_a Module
          expect(mod.name.start_with?('Polyfill::Module::')).to be true
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
              expect { Dir.empty?('.') }.to_not raise_error
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
            end.to raise_error(NameError)

            expect do
              Polyfill(Array: :all, version: '2.2')
            end.to raise_error(ArgumentError, '"Array" has no updates')
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

        context 'load order' do
          using Polyfill(
            Enumerable: %w[#sum],
            Array: %w[#sum]
          )

          it 'loads modules before classes' do
            # the Array version does not use `each`
            obj = [1, 2, 3]
            expect(obj).to_not receive(:each)
            obj.sum
          end
        end
      end
    end
  end
end
