module Polyfill
  module V2_5
    module Hash
      def slice(*keys)
        keys.each_with_object({}) do |k, acc|
          acc[k] = self[k] if key?(k)
        end
      end
    end
  end
end
