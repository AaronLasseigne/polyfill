module Polyfill
  module V2_6
    module Kernel
      using Polyfill(Kernel: %w[#yield_self], version: '2.5')
      alias then yield_self
    end
  end
end
