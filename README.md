# Polyfill

[![Build](https://travis-ci.org/AaronLasseigne/polyfill.svg?branch=master)](https://travis-ci.org/AaronLasseigne/polyfill)

Polyfill implements newer Ruby features into older versions. If the Ruby
version already supports the polyfill then calling it does nothing. This is
designed to allow gem maintainers to use newer methods and gain their
advantages while retaining backwards compatibility. It can also be used for
code that would like newer features but is not completely ready to upgrade
Ruby versions. The polyfills are built using refinements so there is **no
monkey patching** that may cause issues outside of your use.

- [Caveat Emptor](#caveat-emptor)
- [Installation](#installation)
- [Goals](#goals)
- [Usage](#usage)
  - [Polyfill](#polyfill-1)
  - [Polyfill.get](#polyfillget)
- [Implementation Table](#implementation-table)
  - [2.4](#24)
  - [2.3](#23)
  - [2.2](#22)

## Caveat Emptor

Not all features can be perfectly implemented. This is a best effort
implementation but it's best to always test thoroughly across versions.
This project is also currently pre-1.0. Breaking changes may occur on
any release. Once a stable API is built it will be moved to 1.0.0.

See the [implementation table](#implementation-table) for specifics about what has been implemented.

## Installation

Add it to your Gemfile:

```ruby
gem 'polyfill', '0.9.0'
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

### 2.4

| Object           | Method                   | Implemented | Notes |
| ---------------- | ------------------------ | ----------- | ----- |
| Array            | #concat                  | Yes         |
|                  | #max                     | No          | This method already existed but was inherited from `Enumerable`. It was optimized on `Array` so redefining `Enumerable#max` no longer affects this.
|                  | #min                     | No          | This method already existed but was inherited from `Enumerable`. It was optimized on `Array` so redefining `Enumerable#min` no longer affects this.
|                  | #pack                    | No          |
|                  | #sum                     | Yes         |
| BasicObject      | #\_\_send\_\_            | No          |
| Binding          | #irb                     | No          |
| Comparable       | #clamp                   | Yes         |
| CSV              | #new                     | No          |
| Dir              | .empty?                  | Yes         |
| Enumerable       | #chunk                   | Yes         |
|                  | #sum                     | Yes         |
|                  | #uniq                    | Yes         |
| Enumerator::Lazy | #chunk_while             | Yes         |
|                  | #uniq                    | Yes         |
| File             | .empty?                  | Yes         |
| FileTest         | .empty?                  | No          |
| Float            | #ceil                    | Yes         |
|                  | #floor                   | Yes         |
|                  | #round                   | No          |
|                  | #truncate                | Yes         |
| Hash             | #compact                 | Yes         |
|                  | #compact!                | Yes         |
|                  | #transform_values        | Yes         |
|                  | #transform_values!       | Yes         |
| Integer          | #ceil                    | Yes         |
|                  | #digits                  | Yes         |
|                  | #floor                   | Yes         |
|                  | #round                   | Yes         |
|                  | #truncate                | Yes         |
| IO               | #each_line               | Yes         |
|                  | .foreach                 | Yes         |
|                  | #gets                    | Yes         |
|                  | #lines                   | Yes         |
|                  | #readline                | Yes         |
|                  | #readlines               | Yes         |
|                  | .readlines               | Yes         |
| IPAddr           | #==                      | Yes         |
|                  | #<=>                     | Yes         |
| Kernel           | #send                    | No          |
| Logger           | #new                     | No          |
| MatchData        | #named_captures          | Yes         |
|                  | #values_at               | Yes         |
| Module           | #refine                  | No          |
|                  | .used_modules            | No          |
| Net::HTTP        | #post                    | No          |
| Net::FTP         | #new                     | No          |
|                  | #status                  | No          |
| Numeric          | #clone                   | Yes         |
|                  | #dup                     | Yes         |
|                  | #finite?                 | Yes         |
|                  | #infinite?               | Yes         |
| Object           | #clone                   | Yes         |
| OptionParser     | #order                   | No          |
|                  | #order!                  | No          |
|                  | #parse                   | No          |
|                  | #parse!                  | No          |
|                  | #permute                 | No          |
|                  | #permute!                | No          |
| Pathname         | #empty?                  | Yes         |
| Readline         | #quoting_detection_proc  | No          |
|                  | #quoting_detection_proc= | No          |
| REXML::Element   | #[]                      | No          |
| Rational         | #round                   | No          |
| Regexp           | #match?                  | Yes         |
| Set              | #compare_by_identity     | No          |
|                  | #compare_by_identity?    | No          |
| String           | #capitalize              | No          |
|                  | #capitalize!             | No          |
|                  | #casecmp?                | Partial     | Does not support Unicode characters.
|                  | #concat                  | Yes         |
|                  | #downcase                | No          |
|                  | #downcase!               | No          |
|                  | #each_line               | Yes         |
|                  | #lines                   | Yes         |
|                  | #match?                  | Yes         |
|                  | .new                     | Partial     | Allows `:capacity` option to pass but does nothing.
|                  | #prepend                 | Yes         |
|                  | #swapcase                | No          |
|                  | #swapcase!               | No          |
|                  | #unpack1                 | Yes         |
|                  | #upcase                  | No          |
|                  | #upcase!                 | No          |
| StringIO         | #each_line               | Yes         |
|                  | #gets                    | Yes         |
|                  | #readline                | Yes         |
|                  | #readlines               | Yes         |
| Symbol           | #capitalize              | No          |
|                  | #capitalize!             | No          |
|                  | #casecmp?                | Partial     | Does not support Unicode characters.
|                  | #downcase                | No          |
|                  | #downcase!               | No          |
|                  | #match                   | Yes         |
|                  | #match?                  | Yes         |
|                  | #swapcase                | No          |
|                  | #swapcase!               | No          |
|                  | #to_proc                 | No          |
|                  | #upcase                  | No          |
|                  | #upcase!                 | No          |
| Thread           | #report\_on\_exception   | No          |
|                  | .report\_on\_exception   | No          |
| TracePoint       | #callee_id               | No          |
| Warning          | #warn                    | No          |

### 2.3

| Object                  | Method                   | Implemented | Notes |
| ----------------------- | ------------------------ | ----------- | ----- |
| ARGF                    | #read_nonblock           | No          |
| Array                   | #bsearch_index           | No          |
|                         | #dig                     | Yes         |
|                         | #flatten                 | No          |
|                         | #flatten!                | No          |
|                         | #inspect                 | No          |
|                         | #pack                    | No          |
| Base64                  | .urlsafe_encode64        | No          |
|                         | .urlsafe_decode64        | No          |
| BasicSocket             | #recv                    | No          |
|                         | #recv_nonblock           | No          |
|                         | #recvmsg_nonblock        | No          |
|                         | #sendmsg_nonblock        | No          |
| Comparable              | #==                      | No          |
| Coverage                | .peek_result             | No          |
| Enumerable              | #chunk                   | No          |
|                         | #chunk_while             | Yes         |
|                         | #grep_v                  | Yes         |
|                         | #slice_before            | Yes         |
| Enumerator::Lazy        | #grep_v                  | Yes         |
| File                    | .mkfifo                  | No          |
| File::Stat              | #ino                     | No          |
| Hash                    | #<                       | No          |
|                         | #<=                      | No          |
|                         | #>                       | No          |
|                         | #>=                      | No          |
|                         | #dig                     | Yes         |
|                         | #fetch_values            | Yes         |
|                         | #inspect                 | No          |
|                         | #to_proc                 | Partial     | Works in every respect but returns a `lambda` instead of a `proc`. Returning a `proc` may be an error in MRI's implementation. See: https://bugs.ruby-lang.org/issues/12671
| IO                      | #advise                  | No          |
|                         | #close                   | No          |
|                         | #each_codepoint          | No          |
|                         | #wait_readable           | No          |
| Kernel                  | #loop                    | Yes         |
| Logger                  | #level=                  | No          |
|                         | #reopen                  | No          |
| Module                  | #define_method           | No          |
|                         | #deprecate_constant      | No          |
| NameError               | #receiver                | No          |
| Net::FTP                | .default_passive=        | No          |
|                         | #mlst                    | No          |
|                         | #mlsd                    | No          |
| Net::HTTP               | #open_timeout            | No          |
| Numeric                 | #negative?               | Yes         |
|                         | #positive?               | Yes         |
| Object                  | #define_singleton_method | No          |
|                         | #timeout                 | No          |
| ObjectSpace             | .count_symbols           | No          |
|                         | .count_imemo_objects     | No          |
|                         | .internal_class_of       | No          |
|                         | .internal_super_of       | No          |
| OpenSSL::SSL::SSLSocket | #accept_nonblock         | No          |
|                         | #connect_nonblock        | No          |
| Pathname                | #ascend                  | No          |
|                         | #descend                 | No          |
| Queue                   | #close                   | No          |
| Socket                  | #accept_nonblock         | No          |
|                         | #connect_nonblock        | No          |
| String                  | #+@                      | Yes         |
|                         | #-@                      | Yes         |
|                         | .new                     | Yes         |
|                         | #unpack                  | No          |
| StringIO                | #set_encoding            | No          |
| Struct                  | #dig                     | Yes         |
| TCPServer               | #accept_nonblock         | No          |
| Thread                  | #name                    | No          |
|                         | #name=                   | No          |
| UNIXServer              | #accept_nonblock         | No          |
| Vector                  | #round                   | No          |

### 2.2

| Object      | Method                                  | Implemented | Notes |
| ----------  | --------------------------------------- | ----------- | ----- |
| Binding     | #local_variables                        | No          |
|             | #receiver                               | No          |
| Dir         | #fileno                                 | No          |
| Enumerable  | #max                                    | Yes         |
|             | #max_by                                 | Yes         |
|             | #min                                    | Yes         |
|             | #min_by                                 | Yes         |
|             | #slice_after                            | Yes         |
|             | #slice_when                             | Yes         |
| Etc         | .confstr                                | No          |
|             | .sysconf                                | No          |
|             | .nprocessors                            | No          |
|             | .uname                                  | No          |
| Float       | #next_float                             | No          |
|             | #prev_float                             | No          |
| File        | .birthtime                              | No          |
|             | #birthtime                              | No          |
| File::Stat  | #birthtime                              | No          |
| Find        | .find                                   | No          |
| GC          | .latest_gc_info                         | No          |
|             | .stat                                   | No          |
| IO          | #each_codepoint                         | No          |
|             | #nonblock_read                          | No          |
|             | #nonblock_write                         | No          |
|             | #pathconf                               | No          |
| Kernel      | #itself                                 | Yes         |
|             | #throw                                  | No          |
| Math        | .atan2                                  | No          |
|             | .log                                    | No          |
| Matrix      | #+@                                     | No          |
|             | #-@                                     | No          |
|             | #adjugate                               | No          |
|             | #cofactor                               | No          |
|             | #first_minor                            | No          |
|             | .hstack                                 | No          |
|             | #hstack                                 | No          |
|             | #laplace_expansion                      | No          |
|             | .vstack                                 | No          |
|             | #vstack                                 | No          |
| Method      | #curry                                  | No          |
|             | #super_method                           | No          |
| ObjectSpace | .memsize_of                             | No          |
| Pathname    | #/                                      | No          |
|             | #birthtime                              | No          |
|             | #find                                   | No          |
| Prime       | .prime?                                 | No          |
| Process     | .spawn                                  | No          |
| String      | #unicode_normalize                      | No          |
|             | #unicode_normalize!                     | No          |
|             | #unicode_normalized?                    | No          |
| Time        | .httpdate                               | No          |
|             | .parse                                  | No          |
|             | .rfc2822                                | No          |
|             | .strptime                               | No          |
|             | .xmlschema                              | No          |
| TSort       | .each_strongly_connected_component      | No          |
|             | .each_strongly_connected_component_from | No          |
|             | .tsort_each                             | No          |
| Vector      | #+@                                     | Yes         |
|             | #-@                                     | No          |
|             | #angle_with                             | No          |
|             | .basis                                  | No          |
|             | #cross                                  | No          |
|             | #cross_product                          | No          |
|             | #dot                                    | No          |
|             | .independent?                           | No          |
|             | #independent?                           | No          |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AaronLasseigne/polyfill.
Please read the [contributing file](CONTRIBUTING.md) prior to pull requests.

## Credits

Polyfill is licensed under the [MIT License](LICENSE.txt).
