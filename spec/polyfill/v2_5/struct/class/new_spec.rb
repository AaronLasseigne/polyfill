RSpec.describe 'Struct.new' do
  using Polyfill(Struct: %w[.new], version: '2.5')

  context 'existing behavior' do
    let(:struct) { Struct.new(:name, :legs) }

    it 'works' do
      obj = struct.new('elefant', 4)
      expect(obj.name).to eql 'elefant'
      expect(obj.legs).to eql 4
    end
  end

  context '2.5' do
    let(:struct_with_kwa) { Struct.new(:name, :legs, keyword_init: true) }
    let(:struct_without_kwa) { Struct.new(:name, :legs, keyword_init: false) }

    context 'keyword_init: true option' do
      it 'creates a class that accepts keyword arguments to initialize' do
        obj = struct_with_kwa.new(name: 'elefant', legs: 4)
        expect(obj.name).to eql 'elefant'
        expect(obj.legs).to eql 4

        struct = Struct.new('Named', :name, :legs, keyword_init: true)
        obj = struct.new(name: 'elefant', legs: 4)
        expect(obj.name).to eql 'elefant'
        expect(obj.legs).to eql 4
      end

      context 'new class instantiation' do
        it 'accepts arguments as hash as well' do
          # rubocop:disable Style/BracesAroundHashParameters
          obj = struct_with_kwa.new({ legs: 4, name: 'elefant' })
          # rubocop:enable Style/BracesAroundHashParameters
          expect(obj.name).to eql 'elefant'
          expect(obj.legs).to eql 4
        end

        it 'raises ArgumentError when passed not declared keyword argument' do
          expect do
            struct_with_kwa.new(name: 'elefant', legs: 4, foo: 'foo', bar: 'bar')
          end.to raise_error(ArgumentError, 'unknown keywords: foo, bar')

          expect do
            struct_with_kwa.new(name: 'elefant', foo: 'foo')
          end.to raise_error(ArgumentError, 'unknown keywords: foo')
        end

        it 'raises ArgumentError when passed a list of arguments' do
          expect do
            struct_with_kwa.new('elefant', 4)
          end.to raise_error(ArgumentError, /wrong number of arguments/)
        end
      end
    end

    context 'keyword_init: false option' do
      it 'behaves like it does without :keyword_init option' do
        obj = struct_without_kwa.new('elefant', 4)
        expect(obj.name).to eql 'elefant'
        expect(obj.legs).to eql 4
      end
    end
  end
end
