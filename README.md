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

I = Implemented, N = Not Implemented, P = Paritally Implemented

|   | Object           | Method                   | Changes |
| - | ---------------- | ------------------------ | ------- |
| N | Integer          | #ceil                    | Always return an Integer.
| N | Integer          | #floor                   | Always return an Integer.
| N | Integer          | #pow                     | Accepts modulo argument for calculating modular exponentiation.
| N | Integer          | #round                   | Always return an Integer.
| N | Integer          | #step                    | No longer hides errors from coerce method when given a step value which cannot be compared with #> to 0.
| N | Integer          | #truncate                | Always return an Integer.


### 2.4

I = Implemented, N = Not Implemented, P = Paritally Implemented

|   | Object           | Method                   | Changes | Notes |
| - | ---------------- | ------------------------ | ------- | ----- |
| I | Array            | #concat                  |         |
| N |                  | #max                     |         | This method already existed but was inherited from `Enumerable`. It was optimized on `Array` so redefining `Enumerable#max` no longer affects this.
| N |                  | #min                     |         | This method already existed but was inherited from `Enumerable`. It was optimized on `Array` so redefining `Enumerable#min` no longer affects this.
| N |                  | #pack                    |         |
| I |                  | #sum                     |         |
| N | BasicObject      | #\_\_send\_\_            |         |
| N | Binding          | #irb                     |         |
| I | Comparable       | #clamp                   |         |
| N | CSV              | #new                     |         |
| I | Dir              | .empty?                  |         |
| I | Enumerable       | #chunk                   |         |
| I |                  | #sum                     |         |
| I |                  | #uniq                    |         |
| I | Enumerator::Lazy | #chunk_while             |         |
| I |                  | #uniq                    |         |
| I | File             | .empty?                  |         |
| N | FileTest         | .empty?                  |         |
| I | Float            | #ceil                    |         |
| I |                  | #floor                   |         |
| N |                  | #round                   |         |
| I |                  | #truncate                |         |
| I | Hash             | #compact                 |         |
| I |                  | #compact!                |         |
| I |                  | #transform_values        |         |
| I |                  | #transform_values!       |         |
| I | Integer          | #ceil                    |         |
| I |                  | #digits                  |         |
| I |                  | #floor                   |         |
| I |                  | #round                   |         |
| I |                  | #truncate                |         |
| I | IO               | #each_line               |         |
| I |                  | .foreach                 |         |
| I |                  | #gets                    |         |
| I |                  | #lines                   |         |
| I |                  | #readline                |         |
| I |                  | #readlines               |         |
| I |                  | .readlines               |         |
| I | IPAddr           | #==                      |         |
| I |                  | #<=>                     |         |
| N | Kernel           | #send                    |         |
| N | Logger           | #new                     |         |
| I | MatchData        | #named_captures          |         |
| I |                  | #values_at               |         |
| N | Module           | #refine                  |         |
| N |                  | .used_modules            |         |
| N | Net::HTTP        | #post                    |         |
| N | Net::FTP         | #new                     |         |
| N |                  | #status                  |         |
| I | Numeric          | #clone                   |         |
| I |                  | #dup                     |         |
| I |                  | #finite?                 |         |
| I |                  | #infinite?               |         |
| I | Object           | #clone                   |         |
| N | OptionParser     | #order                   |         |
| N |                  | #order!                  |         |
| N |                  | #parse                   |         |
| N |                  | #parse!                  |         |
| N |                  | #permute                 |         |
| N |                  | #permute!                |         |
| I | Pathname         | #empty?                  |         |
| N | Readline         | #quoting_detection_proc  |         |
| N |                  | #quoting_detection_proc= |         |
| N | REXML::Element   | #[]                      |         |
| N | Rational         | #round                   |         |
| I | Regexp           | #match?                  |         |
| N | Set              | #compare_by_identity     |         |
| N |                  | #compare_by_identity?    |         |
| N | String           | #capitalize              |         |
| N |                  | #capitalize!             |         |
| P |                  | #casecmp?                |         | Does not support Unicode characters.
| I |                  | #concat                  |         |
| N |                  | #downcase                |         |
| N |                  | #downcase!               |         |
| I |                  | #each_line               |         |
| I |                  | #lines                   |         |
| I |                  | #match?                  |         |
| P |                  | .new                     |         | Allows `:capacity` option to pass but does nothing.
| I |                  | #prepend                 |         |
| N |                  | #swapcase                |         |
| N |                  | #swapcase!               |         |
| I |                  | #unpack1                 |         |
| N |                  | #upcase                  |         |
| N |                  | #upcase!                 |         |
| I | StringIO         | #each_line               |         |
| I |                  | #gets                    |         |
| I |                  | #readline                |         |
| I |                  | #readlines               |         |
| N | Symbol           | #capitalize              |         |
| N |                  | #capitalize!             |         |
| P |                  | #casecmp?                |         | Does not support Unicode characters.
| N |                  | #downcase                |         |
| N |                  | #downcase!               |         |
| I |                  | #match                   |         |
| I |                  | #match?                  |         |
| N |                  | #swapcase                |         |
| N |                  | #swapcase!               |         |
| N |                  | #to_proc                 |         |
| N |                  | #upcase                  |         |
| N |                  | #upcase!                 |         |
| N | Thread           | #report\_on\_exception   |         |
| N |                  | .report\_on\_exception   |         |
| N | TracePoint       | #callee_id               |         |
| N | Warning          | #warn                    |         |

### 2.3

I = Implemented, N = Not Implemented, P = Paritally Implemented

|   | Object                  | Method                   | Changes | Notes |
| - | ----------------------- | ------------------------ | ------- | ----- |
| N | ARGF                    | #read_nonblock           |         |
| N | Array                   | #bsearch_index           |         |
| I |                         | #dig                     |         |
| N |                         | #flatten                 |         |
| N |                         | #flatten!                |         |
| N |                         | #inspect                 |         |
| N |                         | #pack                    |         |
| N | Base64                  | .urlsafe_encode64        |         |
| N |                         | .urlsafe_decode64        |         |
| N | BasicSocket             | #recv                    |         |
| N |                         | #recv_nonblock           |         |
| N |                         | #recvmsg_nonblock        |         |
| N |                         | #sendmsg_nonblock        |         |
| N | Comparable              | #==                      |         |
| N | Coverage                | .peek_result             |         |
| N | Enumerable              | #chunk                   |         |
| I |                         | #chunk_while             |         |
| I |                         | #grep_v                  |         |
| I |                         | #slice_before            |         |
| I | Enumerator::Lazy        | #grep_v                  |         |
| N | File                    | .mkfifo                  |         |
| N | File::Stat              | #ino                     |         |
| N | Hash                    | #<                       |         |
| N |                         | #<=                      |         |
| N |                         | #>                       |         |
| N |                         | #>=                      |         |
| I |                         | #dig                     |         |
| I |                         | #fetch_values            |         |
| N |                         | #inspect                 |         |
| P |                         | #to_proc                 |         | Works in every respect but returns a `lambda` instead of a `proc`. Returning a `proc` may be an error in MRI's implementation. See: https://bugs.ruby-lang.org/issues/12671
| N | IO                      | #advise                  |         |
| N |                         | #close                   |         |
| N |                         | #each_codepoint          |         |
| N |                         | #wait_readable           |         |
| I | Kernel                  | #loop                    |         |
| N | Logger                  | #level=                  |         |
| N |                         | #reopen                  |         |
| N | Module                  | #define_method           |         |
| N |                         | #deprecate_constant      |         |
| N | NameError               | #receiver                |         |
| N | Net::FTP                | .default_passive=        |         |
| N |                         | #mlst                    |         |
| N |                         | #mlsd                    |         |
| N | Net::HTTP               | #open_timeout            |         |
| I | Numeric                 | #negative?               |         |
| I |                         | #positive?               |         |
| N | Object                  | #define_singleton_method |         |
| N |                         | #timeout                 |         |
| N | ObjectSpace             | .count_symbols           |         |
| N |                         | .count_imemo_objects     |         |
| N |                         | .internal_class_of       |         |
| N |                         | .internal_super_of       |         |
| N | OpenSSL::SSL::SSLSocket | #accept_nonblock         |         |
| N |                         | #connect_nonblock        |         |
| N | Pathname                | #ascend                  |         |
| N |                         | #descend                 |         |
| N | Queue                   | #close                   |         |
| N | Socket                  | #accept_nonblock         |         |
| N |                         | #connect_nonblock        |         |
| I | String                  | #+@                      |         |
| I |                         | #-@                      |         |
| I |                         | .new                     |         |
| N |                         | #unpack                  |         |
| N | StringIO                | #set_encoding            |         |
| I | Struct                  | #dig                     |         |
| N | TCPServer               | #accept_nonblock         |         |
| N | Thread                  | #name                    |         |
| N |                         | #name=                   |         |
| N | UNIXServer              | #accept_nonblock         |         |
| N | Vector                  | #round                   |         |

### 2.2

I = Implemented, N = Not Implemented, P = Paritally Implemented

|   | Object      | Method                                  | Changes | Notes |
| - | ----------  | --------------------------------------- | ------- | ----- |
| N | Binding     | #local_variables                        |         |
| N |             | #receiver                               |         |
| N | Dir         | #fileno                                 |         |
| I | Enumerable  | #max                                    |         |
| I |             | #max_by                                 |         |
| I |             | #min                                    |         |
| I |             | #min_by                                 |         |
| I |             | #slice_after                            |         |
| I |             | #slice_when                             |         |
| N | Etc         | .confstr                                |         |
| N |             | .sysconf                                |         |
| N |             | .nprocessors                            |         |
| N |             | .uname                                  |         |
| N | Float       | #next_float                             |         |
| N |             | #prev_float                             |         |
| N | File        | .birthtime                              |         |
| N |             | #birthtime                              |         |
| N | File::Stat  | #birthtime                              |         |
| N | Find        | .find                                   |         |
| N | GC          | .latest_gc_info                         |         |
| N |             | .stat                                   |         |
| N | IO          | #each_codepoint                         |         |
| N |             | #nonblock_read                          |         |
| N |             | #nonblock_write                         |         |
| N |             | #pathconf                               |         |
| I | Kernel      | #itself                                 |         |
| N |             | #throw                                  |         |
| N | Math        | .atan2                                  |         |
| N |             | .log                                    |         |
| N | Matrix      | #+@                                     |         |
| N |             | #-@                                     |         |
| N |             | #adjugate                               |         |
| N |             | #cofactor                               |         |
| N |             | #first_minor                            |         |
| N |             | .hstack                                 |         |
| N |             | #hstack                                 |         |
| N |             | #laplace_expansion                      |         |
| N |             | .vstack                                 |         |
| N |             | #vstack                                 |         |
| N | Method      | #curry                                  |         |
| N |             | #super_method                           |         |
| N | ObjectSpace | .memsize_of                             |         |
| N | Pathname    | #/                                      |         |
| N |             | #birthtime                              |         |
| N |             | #find                                   |         |
| N | Prime       | .prime?                                 |         |
| N | Process     | .spawn                                  |         |
| N | String      | #unicode_normalize                      |         |
| N |             | #unicode_normalize!                     |         |
| N |             | #unicode_normalized?                    |         |
| N | Time        | .httpdate                               |         |
| N |             | .parse                                  |         |
| N |             | .rfc2822                                |         |
| N |             | .strptime                               |         |
| N |             | .xmlschema                              |         |
| N | TSort       | .each_strongly_connected_component      |         |
| N |             | .each_strongly_connected_component_from |         |
| N |             | .tsort_each                             |         |
| I | Vector      | #+@                                     |         |
| N |             | #-@                                     |         |
| N |             | #angle_with                             |         |
| N |             | .basis                                  |         |
| N |             | #cross                                  |         |
| N |             | #cross_product                          |         |
| N |             | #dot                                    |         |
| N |             | .independent?                           |         |
| N |             | #independent?                           |         |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AaronLasseigne/polyfill.
Please read the [contributing file](CONTRIBUTING.md) prior to pull requests.

## Credits

Polyfill is licensed under the [MIT License](LICENSE.txt).
