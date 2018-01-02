# Polyfill

[![Version](https://badge.fury.io/rb/polyfill.svg)](https://rubygems.org/gems/polyfill)
[![Build](https://travis-ci.org/AaronLasseigne/polyfill.svg?branch=master)](https://travis-ci.org/AaronLasseigne/polyfill)

Polyfill implements newer Ruby features into older versions. If the Ruby
version already supports the polyfill then calling it does nothing. This is
designed to allow gem maintainers to use newer methods and gain their
advantages while retaining backwards compatibility. It can also be used for
code that would like newer features but is not completely ready to upgrade
Ruby versions. The polyfills are built using refinements so there is **no
monkey patching** that may cause issues outside of your use.

- [Installation](#installation)
- [Goals](#goals)
- [Usage](#usage)
  - [Polyfill](#polyfill-1)
  - [Polyfill.get](#polyfillget)
- [Implementation Table](#implementation-table)
  - [2.5](#25)
  - [2.4](#24)
  - [2.3](#23)
  - [2.2](#22)

## Installation

Add it to your Gemfile:

```ruby
gem 'polyfill', '~> 1.0'
```

Or install it manually:

```sh
$ gem install polyfill
```

This project uses [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Goals

1. Features should ideally mimic the true behavior (including bugs, error messages, etc).
2. Features should not significantly burden the runtime.
3. Keep everything modular so users can be specific or broad in their usage.

## Usage

### Polyfill

With the `Polyfill` method, you can polyfill methods for one or more Ruby
objects. Each object is passed as a key. The value is an array of strings
containing the methods you would like to polyfill. Instance methods need to
start with '#' and class methods need to start with '.'.

```ruby
using Polyfill(
  Array: %w[#concat],
  Dir: %w[.empty?],
  Hash: %w[#compact! #transform_values]
)
```

If you want all of the methods for a particular object you can use `:all` in
place of the array.

```ruby
using Polyfill(Numeric: :all)
```

Polyfills can be halted at a maximum version with the `:version` option. The
version must be a string with the major and minor version only.

```ruby
using Polyfill(version: '2.3', Numeric: :all)
```

When you add a method it will not be available in all of the ways a normal
method is. For example, you can't call `send` on a refined method prior to
Ruby 2.4. To gain back some of this support you can set `native: true`.
This currently adds support for `respond_to?`, `__send__`, and `send`.

```ruby
using Polyfill(native: true, Numeric: :all)
```

### Polyfill.get

Prior to Ruby 2.4, refinements do not work on Modules. When using a polyfill
on a module it will instead refine the core classes that use the module. If
you're building your own class, it will not receive the polyfill. Instead,
you can `include` (or `extend` or `prepend`) in a polyfill with `Polyfill.get`.

```ruby
class Foo
  include Comparable
  include Polyfill.get(:Comparable, :all)
end
```

To use specific methods you can pass an array of symbols in place of `:all`.

```ruby
class Foo
  include Comparable
  include Polyfill.get(:Comparable, %i[clamp])
end
```

Like before, the polyfills can be halted at a maximum version with the
`:version` option. The version must be a string with the major and minor
version only.

```ruby
class Foo
  include Comparable
  include Polyfill.get(:Comparable, :all, version: '2.3')
end
```

## Implementation Table

### 2.5

✓ = Implemented, ✗ = Not Implemented, P = Partially Implemented

|   | Object           | Method                   | Changes |
|:-:| ---------------- | ------------------------ | ------- |
| ✓ | Integer          | #ceil                    | Always return an Integer.
| ✓ | Integer          | #floor                   | Always return an Integer.
| ✗ | Integer          | #pow                     | Accepts modulo argument for calculating modular exponentiation.
| ✓ | Integer          | #round                   | Always return an Integer.
| ✗ | Integer          | #step                    | No longer hides errors from coerce method when given a step value which cannot be compared with #> to 0.
| ✓ | Integer          | #truncate                | Always return an Integer.


### 2.4

✓ = Implemented, ✗ = Not Implemented, P = Partially Implemented

|   | Object           | Method                   | Changes | Notes |
|:-:| ---------------- | ------------------------ | ------- | ----- |
| ✓ | Array            | #concat                  |         |
| ✗ |                  | #max                     |         | This method already existed but was inherited from `Enumerable`. ✓t was optimized on `Array` so redefining `Enumerable#max` no longer affects this.
| ✗ |                  | #min                     |         | This method already existed but was inherited from `Enumerable`. ✓t was optimized on `Array` so redefining `Enumerable#min` no longer affects this.
| ✗ |                  | #pack                    |         |
| ✓ |                  | #sum                     |         |
| ✗ | BasicObject      | #\_\_send\_\_            |         |
| ✗ | Binding          | #irb                     |         |
| ✓ | Comparable       | #clamp                   |         |
| ✗ | CSV              | #new                     |         |
| ✓ | Dir              | .empty?                  |         |
| ✓ | Enumerable       | #chunk                   |         |
| ✓ |                  | #sum                     |         |
| ✓ |                  | #uniq                    |         |
| ✓ | Enumerator::Lazy | #chunk_while             |         |
| ✓ |                  | #uniq                    |         |
| ✓ | File             | .empty?                  |         |
| ✗ | FileTest         | .empty?                  |         |
| ✓ | Float            | #ceil                    |         |
| ✓ |                  | #floor                   |         |
| ✗ |                  | #round                   |         |
| ✓ |                  | #truncate                |         |
| ✓ | Hash             | #compact                 |         |
| ✓ |                  | #compact!                |         |
| ✓ |                  | #transform_values        |         |
| ✓ |                  | #transform_values!       |         |
| ✓ | Integer          | #ceil                    |         |
| ✓ |                  | #digits                  |         |
| ✓ |                  | #floor                   |         |
| ✓ |                  | #round                   |         |
| ✓ |                  | #truncate                |         |
| ✓ | IO               | #each_line               |         |
| ✓ |                  | .foreach                 |         |
| ✓ |                  | #gets                    |         |
| ✓ |                  | #lines                   |         |
| ✓ |                  | #readline                |         |
| ✓ |                  | #readlines               |         |
| ✓ |                  | .readlines               |         |
| ✓ | IPAddr           | #==                      |         |
| ✓ |                  | #<=>                     |         |
| ✗ | Kernel           | #send                    |         |
| ✗ | Logger           | #new                     |         |
| ✓ | MatchData        | #named_captures          |         |
| ✓ |                  | #values_at               |         |
| ✗ | Module           | #refine                  |         |
| ✗ |                  | .used_modules            |         |
| ✗ | Net::HTTP        | #post                    |         |
| ✗ | Net::FTP         | #new                     |         |
| ✗ |                  | #status                  |         |
| ✓ | Numeric          | #clone                   |         |
| ✓ |                  | #dup                     |         |
| ✓ |                  | #finite?                 |         |
| ✓ |                  | #infinite?               |         |
| ✓ | Object           | #clone                   |         |
| ✗ | OptionParser     | #order                   |         |
| ✗ |                  | #order!                  |         |
| ✗ |                  | #parse                   |         |
| ✗ |                  | #parse!                  |         |
| ✗ |                  | #permute                 |         |
| ✗ |                  | #permute!                |         |
| ✓ | Pathname         | #empty?                  |         |
| ✗ | Readline         | #quoting_detection_proc  |         |
| ✗ |                  | #quoting_detection_proc= |         |
| ✗ | REXML::Element   | #[]                      |         |
| ✗ | Rational         | #round                   |         |
| ✓ | Regexp           | #match?                  |         |
| ✗ | Set              | #compare_by_identity     |         |
| ✗ |                  | #compare_by_identity?    |         |
| ✗ | String           | #capitalize              |         |
| ✗ |                  | #capitalize!             |         |
| P |                  | #casecmp?                |         | Does not support Unicode characters.
| ✓ |                  | #concat                  |         |
| ✗ |                  | #downcase                |         |
| ✗ |                  | #downcase!               |         |
| ✓ |                  | #each_line               |         |
| ✓ |                  | #lines                   |         |
| ✓ |                  | #match?                  |         |
| P |                  | .new                     |         | Allows `:capacity` option to pass but does nothing.
| ✓ |                  | #prepend                 |         |
| ✗ |                  | #swapcase                |         |
| ✗ |                  | #swapcase!               |         |
| ✓ |                  | #unpack1                 |         |
| ✗ |                  | #upcase                  |         |
| ✗ |                  | #upcase!                 |         |
| ✓ | StringIO         | #each_line               |         |
| ✓ |                  | #gets                    |         |
| ✓ |                  | #readline                |         |
| ✓ |                  | #readlines               |         |
| ✗ | Symbol           | #capitalize              |         |
| ✗ |                  | #capitalize!             |         |
| P |                  | #casecmp?                |         | Does not support Unicode characters.
| ✗ |                  | #downcase                |         |
| ✗ |                  | #downcase!               |         |
| ✓ |                  | #match                   |         |
| ✓ |                  | #match?                  |         |
| ✗ |                  | #swapcase                |         |
| ✗ |                  | #swapcase!               |         |
| ✗ |                  | #to_proc                 |         |
| ✗ |                  | #upcase                  |         |
| ✗ |                  | #upcase!                 |         |
| ✗ | Thread           | #report\_on\_exception   |         |
| ✗ |                  | .report\_on\_exception   |         |
| ✗ | TracePoint       | #callee_id               |         |
| ✗ | Warning          | #warn                    |         |

### 2.3

✓ = Implemented, ✗ = Not Implemented, P = Partially Implemented

|   | Object                  | Method                   | Changes | Notes |
|:-:| ----------------------- | ------------------------ | ------- | ----- |
| ✗ | ARGF                    | #read_nonblock           |         |
| ✗ | Array                   | #bsearch_index           |         |
| ✓ |                         | #dig                     |         |
| ✗ |                         | #flatten                 |         |
| ✗ |                         | #flatten!                |         |
| ✗ |                         | #inspect                 |         |
| ✗ |                         | #pack                    |         |
| ✗ | Base64                  | .urlsafe_encode64        |         |
| ✗ |                         | .urlsafe_decode64        |         |
| ✗ | BasicSocket             | #recv                    |         |
| ✗ |                         | #recv_nonblock           |         |
| ✗ |                         | #recvmsg_nonblock        |         |
| ✗ |                         | #sendmsg_nonblock        |         |
| ✗ | Comparable              | #==                      |         |
| ✗ | Coverage                | .peek_result             |         |
| ✗ | Enumerable              | #chunk                   |         |
| ✓ |                         | #chunk_while             |         |
| ✓ |                         | #grep_v                  |         |
| ✓ |                         | #slice_before            |         |
| ✓ | Enumerator::Lazy        | #grep_v                  |         |
| ✗ | File                    | .mkfifo                  |         |
| ✗ | File::Stat              | #ino                     |         |
| ✗ | Hash                    | #<                       |         |
| ✗ |                         | #<=                      |         |
| ✗ |                         | #>                       |         |
| ✗ |                         | #>=                      |         |
| ✓ |                         | #dig                     |         |
| ✓ |                         | #fetch_values            |         |
| ✗ |                         | #inspect                 |         |
| P |                         | #to_proc                 |         | Works in every respect but returns a `lambda` instead of a `proc`. Returning a `proc` may be an error in MRI's implementation. See: https://bugs.ruby-lang.org/issues/12671
| ✗ | IO                      | #advise                  |         |
| ✗ |                         | #close                   |         |
| ✗ |                         | #each_codepoint          |         |
| ✗ |                         | #wait_readable           |         |
| ✓ | Kernel                  | #loop                    |         |
| ✗ | Logger                  | #level=                  |         |
| ✗ |                         | #reopen                  |         |
| ✗ | Module                  | #define_method           |         |
| ✗ |                         | #deprecate_constant      |         |
| ✗ | NameError               | #receiver                |         |
| ✗ | Net::FTP                | .default_passive=        |         |
| ✗ |                         | #mlst                    |         |
| ✗ |                         | #mlsd                    |         |
| ✗ | Net::HTTP               | #open_timeout            |         |
| ✓ | Numeric                 | #negative?               |         |
| ✓ |                         | #positive?               |         |
| ✗ | Object                  | #define_singleton_method |         |
| ✗ |                         | #timeout                 |         |
| ✗ | ObjectSpace             | .count_symbols           |         |
| ✗ |                         | .count_imemo_objects     |         |
| ✗ |                         | .internal_class_of       |         |
| ✗ |                         | .internal_super_of       |         |
| ✗ | OpenSSL::SSL::SSLSocket | #accept_nonblock         |         |
| ✗ |                         | #connect_nonblock        |         |
| ✗ | Pathname                | #ascend                  |         |
| ✗ |                         | #descend                 |         |
| ✗ | Queue                   | #close                   |         |
| ✗ | Socket                  | #accept_nonblock         |         |
| ✗ |                         | #connect_nonblock        |         |
| ✓ | String                  | #+@                      |         |
| ✓ |                         | #-@                      |         |
| ✓ |                         | .new                     |         |
| ✗ |                         | #unpack                  |         |
| ✗ | String✓O                | #set_encoding            |         |
| ✓ | Struct                  | #dig                     |         |
| ✗ | TCPServer               | #accept_nonblock         |         |
| ✗ | Thread                  | #name                    |         |
| ✗ |                         | #name=                   |         |
| ✗ | UN✓XServer              | #accept_nonblock         |         |
| ✗ | Vector                  | #round                   |         |

### 2.2

✓ = Implemented, ✗ = Not Implemented, P = Partially Implemented

|   | Object      | Method                                  | Changes | Notes |
|:-:| ----------  | --------------------------------------- | ------- | ----- |
| ✗ | Binding     | #local_variables                        |         |
| ✗ |             | #receiver                               |         |
| ✗ | Dir         | #fileno                                 |         |
| ✓ | Enumerable  | #max                                    |         |
| ✓ |             | #max_by                                 |         |
| ✓ |             | #min                                    |         |
| ✓ |             | #min_by                                 |         |
| ✓ |             | #slice_after                            |         |
| ✓ |             | #slice_when                             |         |
| ✗ | Etc         | .confstr                                |         |
| ✗ |             | .sysconf                                |         |
| ✗ |             | .nprocessors                            |         |
| ✗ |             | .uname                                  |         |
| ✗ | Float       | #next_float                             |         |
| ✗ |             | #prev_float                             |         |
| ✗ | File        | .birthtime                              |         |
| ✗ |             | #birthtime                              |         |
| ✗ | File::Stat  | #birthtime                              |         |
| ✗ | Find        | .find                                   |         |
| ✗ | GC          | .latest_gc_info                         |         |
| ✗ |             | .stat                                   |         |
| ✗ | IO          | #each_codepoint                         |         |
| ✗ |             | #nonblock_read                          |         |
| ✗ |             | #nonblock_write                         |         |
| ✗ |             | #pathconf                               |         |
| ✓ | Kernel      | #itself                                 |         |
| ✗ |             | #throw                                  |         |
| ✗ | Math        | .atan2                                  |         |
| ✗ |             | .log                                    |         |
| ✗ | Matrix      | #+@                                     |         |
| ✗ |             | #-@                                     |         |
| ✗ |             | #adjugate                               |         |
| ✗ |             | #cofactor                               |         |
| ✗ |             | #first_minor                            |         |
| ✗ |             | .hstack                                 |         |
| ✗ |             | #hstack                                 |         |
| ✗ |             | #laplace_expansion                      |         |
| ✗ |             | .vstack                                 |         |
| ✗ |             | #vstack                                 |         |
| ✗ | Method      | #curry                                  |         |
| ✗ |             | #super_method                           |         |
| ✗ | ObjectSpace | .memsize_of                             |         |
| ✗ | Pathname    | #/                                      |         |
| ✗ |             | #birthtime                              |         |
| ✗ |             | #find                                   |         |
| ✗ | Prime       | .prime?                                 |         |
| ✗ | Process     | .spawn                                  |         |
| ✗ | String      | #unicode_normalize                      |         |
| ✗ |             | #unicode_normalize!                     |         |
| ✗ |             | #unicode_normalized?                    |         |
| ✗ | Time        | .httpdate                               |         |
| ✗ |             | .parse                                  |         |
| ✗ |             | .rfc2822                                |         |
| ✗ |             | .strptime                               |         |
| ✗ |             | .xmlschema                              |         |
| ✗ | TSort       | .each_strongly_connected_component      |         |
| ✗ |             | .each_strongly_connected_component_from |         |
| ✗ |             | .tsort_each                             |         |
| ✓ | Vector      | #+@                                     |         |
| ✗ |             | #-@                                     |         |
| ✗ |             | #angle_with                             |         |
| ✗ |             | .basis                                  |         |
| ✗ |             | #cross                                  |         |
| ✗ |             | #cross_product                          |         |
| ✗ |             | #dot                                    |         |
| ✗ |             | .independent?                           |         |
| ✗ |             | #independent?                           |         |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AaronLasseigne/polyfill.
Please read the [contributing file](CONTRIBUTING.md) prior to pull requests.

## Credits

Polyfill is licensed under the [MIT License](LICENSE.txt).
