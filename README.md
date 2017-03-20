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
gem 'polyfill', '0.4.0'
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

To specify methods from a particular object use it's class name and pass an
array of strings containing the methods you'd like to use. Instance methods
need to start with "#" and class methods need to start with ".".

```ruby
using Polyfill(
  Array: %w[#concat],
  Dir: %w[.empty?],
  Hash: %w[#compact! #transform_values],
)
```

If you want all of the methods for a particular class you can use `:all`.

```ruby
using Polyfill(Numeric: :all)
```

Methods can be included in the same way. Prior to Ruby 2.4, refinements did
not work on modules. In order to get methods you'll need to include them after
the module. Calling `using` on a module will add it to all core Ruby classes
that include it. The methods will only be included if they are needed by the
Ruby version running the code.

```ruby
class Foo
  include Comparable
  include Polyfill(Comparable: %w[#clamp])
end
```

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
| Dir              | .empty?                | Yes         |
| Enumerable       | #chunk                 | No          |
|                  | #sum                   | No          |
|                  | #uniq                  | No          |
| Enumerator::Lazy | #chunk_while           | No          |
|                  | #uniq                  | No          |
| File             | .empty?                | Yes         |
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
| IO               | #each_line             | Yes         |
|                  | .foreach               | Yes         |
|                  | #gets                  | Yes         |
|                  | #lines                 | Yes         |
|                  | #readline              | Yes         |
|                  | #readlines             | Yes         |
|                  | .readlines             | Yes         |
| Kernel           | #clone                 | No          |
| MatchData        | #named_captures        | Yes         |
|                  | #values_at             | Yes         |
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
|                  | #each_line             | Yes         |
|                  | #lines                 | Yes         |
|                  | #match?                | No          |
|                  | .new                   | No          |
|                  | #prepend               | Yes         |
|                  | #swapcase              | No          |
|                  | #swapcase!             | No          |
|                  | #unpack1               | Yes         |
|                  | #upcase                | No          |
|                  | #upcase!               | No          |
| StringIO         | #each_line             | Yes         |
|                  | #gets                  | Yes         |
|                  | #readline              | Yes         |
|                  | #readlines             | Yes         |
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
