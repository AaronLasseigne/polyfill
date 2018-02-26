module Polyfill
  module V2_5
    module Dir
      module ClassMethods
        def children(dirname, encoding: Encoding.find('filesystem'))
          entries(dirname, encoding: encoding) - %w[. ..]
        end
      end
    end
  end
end
