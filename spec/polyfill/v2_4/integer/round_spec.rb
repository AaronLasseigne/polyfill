RSpec.describe 'Integer#round' do
  using Polyfill::V2_4::Integer::Round

  context 'existing behavior' do
    it 'returns itself' do
      expect(1.round).to eql 1
    end
  end

  context '2.4' do
    it 'returns itself when called with 0' do
      expect(1.round(0)).to eql 1
    end

    it 'returns a float of the number when called with > 0' do
      expect(1.round(1)).to eql 1.0
    end

    it 'rounds up when called with < 0' do
      expect(14.round(-1)).to eql 10
      expect(15.round(-1)).to eql 20
      expect(15.round(-2)).to eql 0
      expect(-14.round(-1)).to eql(-10)
      expect(-15.round(-1)).to eql(-20)
    end

    it 'calls to_int on anything passed' do
      value = double('value')
      expect(value).to receive(:to_int).and_return(1)
      1.round(value)
    end

    context 'optional :half' do
      it 'does nothing' do
        expect(1.round(0, half: nil)).to eql 1
        expect(1.round(0, half: :down)).to eql 1
        expect(1.round(0, half: :even)).to eql 1
        expect(1.round(0, half: :up)).to eql 1
        expect(1.round(0, half: 'down')).to eql 1
        expect(1.round(0, half: 'even')).to eql 1
        expect(1.round(0, half: 'up')).to eql 1
      end

      it 'throws an error if an invalid mode is passed' do
        expect { 1.round(0, half: :garbage) }.to raise_error(ArgumentError, 'invalid rounding mode: garbage')

        # no implicit conversion occurs
        s = double('s')
        allow(s).to receive(:to_sym).and_return(:even)
        allow(s).to receive(:intern).and_return(:even)
        expect { 1.round(0, half: s) }.to raise_error(ArgumentError)
      end
    end
  end
end
