RSpec.describe 'Object#clone' do
  using Polyfill(Object: %w[#clone])

  let(:ext) do
    Module.new do
      def b
        :b
      end
    end
  end
  let(:obj) do
    obj = Struct.new(:a).new(:a)
    obj.extend(ext)
    obj.freeze
    obj
  end

  context 'existing behavior' do
    it 'works' do
      clone = obj.clone

      expect(clone.a).to eql :a
      expect(clone.b).to eql :b
      expect(clone).to be_frozen
    end
  end

  context '2.4' do
    it 'can unfreeze clones' do
      clone = obj.clone(freeze: false)

      expect(clone.a).to eql :a
      expect(clone.b).to eql :b
      expect(clone).to_not be_frozen
    end

    it 'can keep clones frozen' do
      clone = obj.clone(freeze: true)

      expect(clone.a).to eql :a
      expect(clone.b).to eql :b
      expect(clone).to be_frozen
    end
  end
end
