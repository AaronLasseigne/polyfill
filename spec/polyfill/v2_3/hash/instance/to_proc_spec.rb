RSpec.describe 'Hash#to_proc' do
  using Polyfill(Hash: %w[#to_proc], version: '2.3')

  let(:key) { Object.new }
  let(:value) { Object.new }
  let(:hash) { { key => value } }
  let(:default) { Object.new }
  let(:unstored) { Object.new }

  it 'returns an instance of Proc' do
    expect(hash.to_proc).to be_an_instance_of Proc
  end

  context 'the returned proc' do
    let(:proc) { hash.to_proc }

    # see: https://bugs.ruby-lang.org/issues/12671
    # it 'is not a lambda' do
    #   expect(proc.lambda?).to be false
    # end

    it 'raises ArgumentError if not passed exactly one argument' do
      expect { proc.call }.to raise_error(ArgumentError)
      expect { proc.call 1, 2 }.to raise_error(ArgumentError)
    end

    context 'with a stored key' do
      it 'returns the paired value' do
        expect(proc.call(key)).to equal value
      end
    end

    context 'passed as a block' do
      it "retrieves the hash's values" do
        expect([key].map(&proc)[0]).to equal value
      end

      context 'to instance_exec' do
        it "always retrieves the original hash's values" do
          hash = { foo: 1, bar: 2 }
          proc = hash.to_proc

          expect(hash.instance_exec(:foo, &proc)).to eql 1

          hash2 = { quux: 1 }
          expect(hash2.instance_exec(:foo, &proc)).to eql 1
        end
      end
    end

    context 'with no stored key' do
      it 'returns nil' do
        expect(proc.call(unstored)).to be_nil
      end

      context 'when the hash has a default value' do
        before :each do
          hash.default = default
        end

        it 'returns the default value' do
          expect(proc.call(unstored)).to equal default
        end
      end

      context 'when the hash has a default proc' do
        it 'returns an evaluated value from the default proc' do
          hash.default_proc = ->(hash, called_with) { [hash.keys, called_with] }
          expect(proc.call(unstored)).to eql [[key], unstored]
        end
      end
    end

    it 'raises an ArgumentError when calling #call on the Proc with no arguments' do
      expect { hash.to_proc.call }.to raise_error(ArgumentError)
    end
  end
end
