# [0.3.0][]

## Added

 - v2.4 Dir.empty?
 - v2.4 File.empty?
 - v2.4 IO#each_line
 - v2.4 IO.foreach
 - v2.4 IO#gets
 - v2.4 IO#readline
 - v2.4 IO#readlines
 - v2.4 IO.readlines

## Changes

 - New way to select methods that doesn't rely on knowing the module structure

# [0.2.0][] (2017-03-16)

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

[0.3.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.0.0...v0.1.0
