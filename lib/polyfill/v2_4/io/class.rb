require_relative 'class/foreach'
require_relative 'class/readlines'

module Polyfill
  module V2_4
    module IO
      module Class
        include Foreach
        include Readlines
      end
    end
  end
end
