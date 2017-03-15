# Polyfill

[![Build](https://travis-ci.org/AaronLasseigne/polyfill.svg?branch=master)](https://travis-ci.org/AaronLasseigne/polyfill)

Polyfill implements newer Ruby features into older versions. If the Ruby
version already supports the polyfill then calling it does nothing. This is
designed to allow gem maintainers to use newer methods and gain their
advantages while retaining backwards compatibility. It can also be used for
code that would like newer features but is not completely ready to upgrade
Ruby versions. The polyfills are built using refinements so there is **no
monkey patching** that may cause issues outside of your use.

Right now the only update is from 2.3 to 2.4 however the goal is to go all the way back to 2.0 (when refinements were introduced). Additionally, core methods are being focused on but stdlib will eventually be added.

- [Caveat Emptor](#caveat-emptor)
- [Installation](#installation)
- [Goals](#goals)
- [Usage](#usage)
- [Implementation Table](#implementation-table)

## Caveat Emptor

Not all features can be perfectly implemented. This is a best effort
implementation but it's best to always test thoroughly across versions.
This project is also currently pre-1.0. Breaking changes may occur on
any release. Once a stable API is built it will be moved to 1.0.0.

See the [implementation table](#implementation-table) for specifics about what has been implemented.

## Installation

Add it to your Gemfile:

```ruby
gem 'polyfill', '0.1.0'
```

Or install it manually:

```sh
$ gem install polyfill
```

This project uses [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Goals

1. Features should ideally mimic the true behavior (including bugs).
2. Features should not significantly burden the runtime.
3. Keep everything modular so users can be specific or broad in their usage.

## Usage

To use all updates:

```ruby
using Polyfill
```

To use all updates up to V2_4:

```ruby
using Polyfill::V2_4
```

To use all updates for a particular object, add it to the end:

```ruby
using Polyfill::V2_4::Array
using Polyfill::V2_4::String
```

To use a particular method, we can add it after the object. The method is
converted to camel case. Predicate methods (ending with a question mark)
have their question converted to a `Q`. Dangerous methods (ending with an
exclamation mark) have their exclamation replaced with `E`.

```ruby
using Polyfill::V2_4::Array::Concat
using Polyfill::V2_4::Dir::EmptyQ # :empty?
using Polyfill::V2_4::Hash::CompactE # :compact!
using Polyfill::V2_4::Hash::TransformValues # :transform_values!
```

Any method can be accessed as a stand-alone module by adding `Method` to
the end:

```ruby
include Polyfill::V2_4::Comparable::Clamp::Method
```

**A note about modules:** Prior to 2.4, refinements do not work on modules.
This means modules like `Comparable` will apply the refinement to all child
classes. Anything custom classes that inherit from `Comparable` will be
unaffected by the refinement. In cases like this you can use `include` as
demonstrated above to pull in the needed method. Just like always, the
method is only defined if the Ruby version requires it.


## Implementation Table

### 2.3 to 2.4

| Object           | Method                 | Implemented | Notes |
| ---------------- | ---------------------- | ----------- | ----- |
| Array            | #concat                | Yes         |
|                  | #max                   | No          |
|                  | #min                   | No          |
|                  | #pack                  | No          |
|                  | #sum                   | No          |
| Comparable       | #clamp                 | Yes         |
| Dir              | #empty?                | No          |
| Enumerable       | #chunk                 | No          |
|                  | #sum                   | No          |
|                  | #uniq                  | No          |
| Enumerator::Lazy | #chunk_while           | No          |
|                  | #uniq                  | No          |
| File             | #empty?                | No          |
| Float            | #ceil                  | Yes         |
|                  | #floor                 | Yes         |
|                  | #round                 | No          |
|                  | #truncate              | Yes         |
| Hash             | #compact               | Yes         |
|                  | #compact!              | Yes         |
|                  | #transform_values      | Yes         |
|                  | #transform_values!     | Yes         |
| Integer          | #ceil                  | Yes         |
|                  | #digits                | Yes         |
|                  | #floor                 | Yes         |
|                  | #round                 | Yes         |
|                  | #truncate              | Yes         |
| IO               | #each_line             | No          |
|                  | .foreach               | No          |
|                  | #gets                  | No          |
|                  | #readline              | No          |
|                  | #readlines             | No          |
| Kernel           | #clone                 | No          |
| MatchData        | #named_captures        | Yes         |
|                  | #values_at             | No          |
| Module           | #refine                | No          |
|                  | .used_modules          | No          |
| Numeric          | #finite?               | Yes         |
|                  | #infinite?             | Yes         |
| Rational         | #round                 | No          |
| Regexp           | #match?                | No          |
| String           | #capitalize            | No          |
|                  | #capitalize!           | No          |
|                  | #casecmp?              | No          |
|                  | #concat                | Yes         |
|                  | #downcase              | No          |
|                  | #downcase!             | No          |
|                  | #each_line             | No          |
|                  | #lines                 | No          |
|                  | #match?                | No          |
|                  | .new                   | No          |
|                  | #prepend               | Yes         |
|                  | #swapcase              | No          |
|                  | #swapcase!             | No          |
|                  | #unpack1               | No          |
|                  | #upcase                | No          |
|                  | #upcase!               | No          |
| StringIO         | #each_line             | No          |
|                  | #gets                  | No          |
|                  | #readline              | No          |
|                  | #readlines             | No          |
| Symbol           | #capitalize            | No          |
|                  | #capitalize!           | No          |
|                  | #casecmp?              | No          |
|                  | #downcase              | No          |
|                  | #downcase!             | No          |
|                  | #match                 | No          |
|                  | #match?                | No          |
|                  | #swapcase              | No          |
|                  | #swapcase!             | No          |
|                  | #upcase                | No          |
|                  | #upcase!               | No          |
| Thread           | #report\_on\_exception | No          |
|                  | .report\_on\_exception | No          |
| TracePoint       | #callee_id             | No          |
| Warning          | #warn                  | No          |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AaronLasseigne/polyfill.
Please read the [contributing file](CONTRIBUTING.md) prior to pull requests.

## Credits

Polyfill is licensed under the [MIT License](LICENSE.md).
