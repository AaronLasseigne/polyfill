RSpec.describe 'Polyfill.get' do
  context 'arguments' do
    it 'errors on invalid keys' do
      expect do
        Polyfill.get(:Enumerable, :all, invalid_key: :all)
      end.to raise_error(ArgumentError, 'unknown keyword: invalid_key')
    end

    it 'fails on invalid modules' do
      module OuterMod
        module InnerMod
        end
      end

      expect do
        Polyfill.get(:OuterMod, :all)
      end.to raise_error(ArgumentError, '"OuterMod" has no updates')

      expect do
        Polyfill.get(:'OuterMod::InnerMod', :all)
      end.to raise_error(ArgumentError, '"OuterMod::InnerMod" has no updates')

      expect do
        Polyfill.get(:String, :all)
      end.to raise_error(ArgumentError, 'String is a class not a module')
    end

    it 'fails on invalid methods' do
      expect do
        Polyfill.get(:Enumerable, %i[this_is_not_a_method])
      end.to raise_error(ArgumentError, '"#this_is_not_a_method" is not a valid method on Enumerable or has no updates')
    end

    context ':version' do
      it 'errors on invalid version numbers' do
        expect do
          Polyfill.get(:Enumerable, :all, version: 'invalid')
        end.to raise_error(ArgumentError, 'invalid value for keyword version: invalid')
      end
    end
  end

  context 'included' do
    it 'can include everything for a class' do
      obj = Class.new do
        include Enumerable
        include Polyfill.get(:Enumerable, :all)
      end.new

      expect(obj.respond_to?(:grep_v)).to be true
      expect(obj.respond_to?(:sum)).to be true
      expect(obj.respond_to?(:slice_after)).to be true
    end

    it 'can include particular methods for a class' do
      obj = Class.new do
        include Enumerable
        include Polyfill.get(:Enumerable, %i[grep_v slice_after])
      end.new

      expect(obj.respond_to?(:grep_v)).to be true
      when_ruby_below '2.4' do
        expect(obj.respond_to?(:sum)).to be false
      end
      expect(obj.respond_to?(:slice_after)).to be true
    end

    context 'with arguments' do
      context ':version' do
        it 'includes everything for a valid version number' do
          obj = Class.new do
            include Enumerable
            include Polyfill.get(:Enumerable, :all, version: '2.3')
          end.new

          expect(obj.respond_to?(:grep_v)).to be true
          when_ruby_below '2.4' do
            expect(obj.respond_to?(:sum)).to be false
          end
          expect(obj.respond_to?(:slice_after)).to be true
        end
      end
    end
  end

  context 'extended' do
    it 'can extend everything for a class' do
      klass = Class.new do
        extend Enumerable
        extend Polyfill.get(:Enumerable, :all)
      end

      expect(klass.respond_to?(:grep_v)).to be true
      expect(klass.respond_to?(:sum)).to be true
      expect(klass.respond_to?(:slice_after)).to be true
    end

    it 'can extend particular methods for a class' do
      klass = Class.new do
        extend Enumerable
        extend Polyfill.get(:Enumerable, %i[grep_v slice_after])
      end

      expect(klass.respond_to?(:grep_v)).to be true
      when_ruby_below '2.4' do
        expect(klass.respond_to?(:sum)).to be false
      end
      expect(klass.respond_to?(:slice_after)).to be true
    end

    context 'with arguments' do
      context ':version' do
        it 'extends everything for a valid version number' do
          klass = Class.new do
            extend Enumerable
            extend Polyfill.get(:Enumerable, :all, version: '2.3')
          end

          expect(klass.respond_to?(:grep_v)).to be true
          when_ruby_below '2.4' do
            expect(klass.respond_to?(:sum)).to be false
          end
          expect(klass.respond_to?(:slice_after)).to be true
        end
      end
    end
  end
end
