require_relative 'v2_4/array'
require_relative 'v2_4/comparable'
require_relative 'v2_4/dir'
require_relative 'v2_4/enumerable'
require_relative 'v2_4/file'
require_relative 'v2_4/float'
require_relative 'v2_4/hash'
require_relative 'v2_4/integer'
require_relative 'v2_4/io'
require_relative 'v2_4/match_data'
require_relative 'v2_4/numeric'
require_relative 'v2_4/regexp'
require_relative 'v2_4/string'
require_relative 'v2_4/string_io'
require_relative 'v2_4/symbol'

module Polyfill
  module V2_4
    include Array
    include Comparable
    include Dir
    include Enumerable
    include File
    include Float
    include Hash
    include Integer
    include IO
    include MatchData
    include Numeric
    include Regexp
    include String
    include StringIO
    include Symbol
  end
end
