RSpec.describe 'Kernel#loop' do
  using Polyfill(Kernel: %w[#loop], version: '2.3')

  context 'existing behavior' do
    it 'is a private method' do
      expect(Kernel.private_instance_methods.include?(:loop)).to be true
    end

    it 'calls block until it is terminated by a break' do
      i = 0
      loop do
        i += 1
        break if i == 10
      end

      expect(i).to eql 10
    end

    it 'returns value passed to break' do
      expect(loop { break 123 }).to eql 123
    end

    it 'returns nil if no value passed to break' do
      expect(loop { break }).to be nil
    end

    it 'returns an enumerator if no block given' do
      enum = loop
      expect(enum.instance_of?(Enumerator)).to be true

      cnt = 0
      expect(
        enum.each do |*args|
          raise 'Args should be empty #{args.inspect}' unless args.empty?
          cnt += 1
          break cnt if cnt >= 42
        end
      ).to eql 42
    end

    it 'rescues StopIteration' do
      expect do
        loop do
          raise StopIteration
        end
      end.to_not raise_error
    end

    it "rescues StopIteration's subclasses" do
      finish = Class.new StopIteration
      expect do
        loop do
          raise finish
        end
      end.to_not raise_error
    end

    it 'does not rescue other errors' do
      expect { loop { raise StandardError } }.to raise_error StandardError
    end

    context 'when no block is given' do
      context 'returned Enumerator' do
        context 'size' do
          it 'returns Float::INFINITY' do
            expect(loop.size).to eql Float::INFINITY
          end
        end
      end
    end
  end

  context '2.3' do
    it 'returns StopIteration#result, the result value of a finished iterator' do
      e = Enumerator.new do |y|
        y << 1
        y << 2
        :stopped
      end
      expect(loop { e.next }).to eql :stopped
    end
  end
end
