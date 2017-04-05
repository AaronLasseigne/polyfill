require_relative 'instance/dig'
require_relative 'instance/fetch_values'
require_relative 'instance/to_proc'

module Polyfill
  module V2_3
    module Hash
      module Instance
        include Dig
        include FetchValues
        include ToProc
      end
    end
  end
end
