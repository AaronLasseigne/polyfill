# [0.7.0][]

## Added

 - Support for Ruby 2.1
 - v2.2 Enumerable#slice_after
 - v2.2 Kernel#itself
 - v2.3 Kernel#loop

# [0.6.0][] (2017-04-06)

## Fix

 - You can now use the `:version` option with no other specification

## Added

 - v2.3 Array#dig
 - v2.3 Enumerable#grep_v
 - v2.3 Enumerable#slice_before
 - v2.3 Enumerator::Lazy#grep_v
 - v2.3 Hash#dig
 - v2.3 Hash#fetch_values
 - v2.3 Hash#to_proc
 - v2.3 String#+@
 - v2.3 String#-@
 - v2.3 Struct#dig

# [0.5.0][] (2017-03-26)

## Added

 - Support for Ruby 2.2
 - `:version` option to limit the max acceptable version for changes
 - v2.3 String.new
 - v2.3 Enumerable#chunk_while

# [0.4.0][] (2017-03-24)

## Added

 - v2.4 Array#sum
 - v2.4 Enumerable#chunk
 - v2.4 Enumerable#sum
 - v2.4 Enumerable#uniq
 - v2.4 Enumerator::Lazy#chunk_while
 - v2.4 Enumerator::Lazy#uniq
 - v2.4 IO#lines
 - v2.4 IPAddr#==
 - v2.4 IPAddr#<=>
 - v2.4 Numeric#clone
 - v2.4 Numeric#dup
 - v2.4 Object#clone
 - v2.4 Pathname#empty?
 - v2.4 Regexp#match?
 - v2.4 String#casecmp?
 - v2.4 String#each_line
 - v2.4 String#lines
 - v2.4 String#match?
 - v2.4 String.new
 - v2.4 String#unpack1
 - v2.4 Symbol#casecmp?
 - v2.4 Symbol#match
 - v2.4 Symbol#match?

# [0.3.0][] (2017-03-19)

## Added

 - v2.4 Dir.empty?
 - v2.4 File.empty?
 - v2.4 IO#each_line
 - v2.4 IO.foreach
 - v2.4 IO#gets
 - v2.4 IO#readline
 - v2.4 IO#readlines
 - v2.4 IO.readlines
 - v2.4 StringIO#each_line
 - v2.4 StringIO#gets
 - v2.4 StringIO#readline
 - v2.4 StringIO#readlines

## Changes

 - New way to select methods that doesn't rely on knowing the module structure

# [0.2.0][] (2017-03-17)

## Added

 - v2.4 MatchData#named_captures
 - v2.4 MatchData#values_at
 - v2.4 Hash#compact
 - v2.4 Hash#compact!
 - v2.4 Hash#transform_values
 - v2.4 Hash#transform_values!

## Changes

 - Modules are camel case instead of only uppercasing the first letter of the method name.
 - Modules for predicate methods now end with `Q` instead of `__Q`.
 - Modules for dangerous methods now end with `E` instead of `__E`.
 - Methods will no longer attempt to fix `#respond_to?`, `#methods`, or `.instance_methods`. This will be revisited later with a more comprehensive solution.

# [0.1.0][] (2017-03-14)

 - v2.4 Array#concat
 - v2.4 Comparable#clamp
 - v2.4 Float#ceil
 - v2.4 Float#floor
 - v2.4 Float#truncate
 - v2.4 Integer#ceil
 - v2.4 Integer#digits
 - v2.4 Integer#floor
 - v2.4 Integer#round
 - v2.4 Integer#truncate
 - v2.4 Numeric#finite?
 - v2.4 Numeric#infinite?
 - v2.4 String#concat?
 - v2.4 String#prepend?

[0.4.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.0.0...v0.1.0
