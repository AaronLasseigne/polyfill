require_relative 'instance/dig'
require_relative 'instance/fetch_values'

module Polyfill
  module V2_3
    module Hash
      module Instance
        include Dig
        include FetchValues
      end
    end
  end
end
