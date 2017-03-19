require 'polyfill/v2_4/io/class/foreach'
require 'polyfill/v2_4/io/class/readlines'

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
