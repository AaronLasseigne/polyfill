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
| ✗ | Array            | #append                  | New (alias for `push`)
| ✗ |                  | #prepend                 | New (alias for `unshift`)
| ✗ | BigDecimal       | #clone                   | Returns the receiver itself instead of making a new instance.
| ✗ |                  | #dup                     | Returns the receiver itself instead of making a new instance.
| ✗ | Dir              | .children                | New
| ✗ |                  | .each_child              | New
| ✗ |                  | #glob                    | Accepts a new optional keyword argument, `:base`.
| ✗ | Enumerable       | #any?                    | Accepts a pattern argument.
| ✗ |                  | #all?                    | Accepts a pattern argument.
| ✗ |                  | #none?                   | Accepts a pattern argument.
| ✗ |                  | #one?                    | Accepts a pattern argument.
| ✗ | ERB              | .result_with_hash        | New
| ✗ | Exception        | #full_message            | New
| ✗ | File             | .identical?              | Support ReFS 128bit ino on Windows 8.1 and later.
| ✗ |                  | .lutime                  | New
| ✗ |                  | .open                    | Accepts a new optional keyword argument, `:newline`.
| ✗ |                  | #path                    | Raises an `IOError` for files opened with `File::Constants::TMPFILE` option.
| ✗ | File::Stat       | #atime                   | Support fractional second timestamps on Windows 8 and later.
| ✗ |                  | #ctime                   | Support fractional second timestamps on Windows 8 and later.
| ✗ |                  | #ino                     | Support ReFS 128bit ino on Windows 8.1 and later.
| ✗ |                  | #mtime                   | Support fractional second timestamps on Windows 8 and later.
| ✗ | Hash             | #slice                   | New
| ✗ |                  | #transform_keys          | New
| ✗ |                  | #transform_keys!         | New
| ✗ | Integer          | #allbits?                | New
| ✗ |                  | #anybits?                | New
| ✓ |                  | #ceil                    | Always return an Integer.
| ✓ |                  | #floor                   | Always return an Integer.
| ✗ |                  | #nobits?                 | New
| ✗ |                  | #pow                     | Same as `**` but it accepts an optional modulo argument for calculating modular exponentiation.
| ✓ |                  | #round                   | Always return an Integer.
| ✗ |                  | .sqrt                    | New
| ✓ |                  | #truncate                | Always return an Integer.
| ✗ | IO               | #pread                   | New
| ✗ |                  | #pwrite                  | New
| ✗ |                  | #write                   | Accepts multiple arguments.
| ✗ | IOError          | #close                   | Instead of raising an error with the message "stream closed", the message will be "stream closed in another thread".
| ✗ | IPAddr           | #link_local?             | New
| ✗ |                  | #loopback?               | New
| ✗ |                  | .new                     | No longer accepts an invalid address mask.
| ✗ |                  | #prefix?                 | New
| ✗ |                  | #private?                | New
| ✗ | Kernel           | #yield_self              | New
| ✗ |                  | #pp                      | New
| ✗ |                  | #warn                    | Accepts a new optional keyword argument, `:uplevel`.
| ✗ | KeyError         | #key                     | New
| ✗ |                  | #receiver                | New
| ✗ | Matrix           | .combine                 | New
| ✗ |                  | #combine                 | New
| ✗ |                  | #entrywise_product       | New
| ✗ |                  | #hadamard_product        | New
| ✗ | Method           | #===                     | New
| ✗ | Module           | #attr                    | Is now public.
| ✗ |                  | #attr_accessor           | Is now public.
| ✗ |                  | #attr_reader             | Is now public.
| ✗ |                  | #attr_writer             | Is now public.
| ✗ |                  | #alias_method            | Is now public.
| ✗ |                  | #define_method           | Is now public.
| ✗ |                  | #remove_method           | Is now public.
| ✗ |                  | #undef_method            | Is now public.
| ✗ | Net::HTTP        | #max_version             | New
| ✗ |                  | #min_version             | New
| ✗ |                  | .new                     | Accepts a new optional keyword argument, `:no_proxy`.
| ✗ |                  | #proxy_pass              | Reflects the http_proxy environment variable if the system's environment variable is multiuser safe.
| ✗ |                  | #proxy_user              | Reflects the http_proxy environment variable if the system's environment variable is multiuser safe.
| ✗ | Numeric          | #<                       | No longer hide exceptions from `#coerce` and will return `nil` if coercion is impossible.
| ✗ |                  | #<=                      | No longer hide exceptions from `#coerce` and will return `nil` if coercion is impossible.
| ✗ |                  | #>                       | No longer hide exceptions from `#coerce` and will return `nil` if coercion is impossible.
| ✗ |                  | #>=                      | No longer hide exceptions from `#coerce` and will return `nil` if coercion is impossible.
| ✗ |                  | #step                    | No longer hides errors from coerce method when given a step value which cannot be compared with #> to 0.
| ✗ | Pathname         | #glob                    | New
| ✗ | Process          | .last_status             | New (alias of `$?`)
| ✗ |                  | .times                   | Precision is improved if getrusage(2) exists.
| ✗ | Range            | .initialize              | No longer hides exceptions when comparing begin and end with `<=>` and raise a "bad value for range" `ArgumentError` but instead lets the exception from the `<=>` call go through.
| ✗ | Random           | #urandom                 | Renamed from `raw_seed`.
| ✗ | SecureRandom     | .alphanumeric            | New
| ✗ | Set              | #===                     | New (alias of `include?`)
| ✗ |                  | #reset                   | New
| ✗ |                  | #to_s                    | New (alias of `inspect`)
| ✗ | String           | #casecmp                 | Returns `nil` for non-string arguments instead of raising a `TypeError`.
| ✗ |                  | #casecmp?                | Returns `nil` for non-string arguments instead of raising a `TypeError`.
| ✗ |                  | #delete_prefix           | New
| ✗ |                  | #delete_prefix!          | New
| ✗ |                  | #delete_suffix           | New
| ✗ |                  | #delete_suffix!          | New
| ✗ |                  | #each_grapheme_cluster   | New
| ✗ |                  | #grapheme_clusters       | New
| ✗ |                  | #start_with?             | Accepts regular expression arguments.
| ✗ |                  | #undump                  | New
| ✗ | StringIO         | #write                   | Accepts multiple arguments.
| ✗ | StringScanner    | #captures                | New
| ✗ |                  | #size                    | New
| ✗ |                  | #values_at               | New
| ✗ | Struct           | .new                     | Accepts a new optional keyword argument, `:keyword_init`.
| ✗ | Thread           | #fetch                   | New
| ✗ |                  | #name=                   | Description set by `Thread#name=` is now visible on Windows 10.
| ✗ | Time             | #at                      | Accepts a third argument which specifies the unit of the second argument.
| ✗ | URI              | .open                    | New (alias of `Kernel.open`)
| ✗ | Zlib::GzipWriter | #write                   | Accepts multiple arguments.

### 2.4

✓ = Implemented, ✗ = Not Implemented, P = Partially Implemented

|   | Object           | Method                   | Changes |
|:-:| ---------------- | ------------------------ | ------- |
| ✓ | Array            | #concat                  | Accepts multiple arguments.
| ✗ |                  | #max                     | This method already existed but was inherited from `Enumerable`. It was optimized on `Array` so redefining `Enumerable#max` no longer affects this.
| ✗ |                  | #min                     | This method already existed but was inherited from `Enumerable`. It was optimized on `Array` so redefining `Enumerable#min` no longer affects this.
| ✗ |                  | #pack                    | Accepts a new optional keyword argument, `buffer`.
| ✓ |                  | #sum                     | Like `Enumerable#sum` but does not depend on the definition of `each`.
| ✗ | BasicObject      | #\_\_send\_\_            | Supports refined methods.
| ✗ | Binding          | #irb                     | Start a REPL session like `binding.pry`.
| ✓ | Comparable       | #clamp                   | New
| ✗ | CSV              | #new                     | Accepts a new optional keyword argument, `liberal_parsing`.
| ✓ | Dir              | .empty?                  | New
| ✓ | Enumerable       | #chunk                   | Calling without a block returns an enumerator.
| ✓ |                  | #sum                     |         |
| ✓ |                  | #uniq                    |         |
| ✓ | Enumerator::Lazy | #chunk_while             |         |
| ✓ |                  | #uniq                    |         |
| ✓ | File             | .empty?                  |         |
| ✗ | FileTest         | .empty?                  |         |
| ✓ | Float            | #ceil                    | Accepts an optional digits argument.
| ✓ |                  | #floor                   | Accepts an optional digits argument.
| ✗ |                  | #round                   | Accepts an optional digits argument and provides a new optional keyword argument, `half`.
| ✓ |                  | #truncate                | Accepts an optional digits argument.
| ✓ | Hash             | #compact                 |         |
| ✓ |                  | #compact!                |         |
| ✓ |                  | #transform_values        |         |
| ✓ |                  | #transform_values!       |         |
| ✓ | Integer          | #ceil                    | Accepts an optional digits argument.
| ✓ |                  | #digits                  |         |
| ✓ |                  | #floor                   | Accepts an optional digits argument.
| ✓ |                  | #round                   | Accepts an optional digits argument and provides a new optional keyword argument, `half`.
| ✓ |                  | #truncate                | Accepts an optional digits argument.
| ✓ | IO               | #each_line               | Accepts a new optional keyword argument, `chomp`.
| ✓ |                  | .foreach                 | Accepts a new optional keyword argument, `chomp`.
| ✓ |                  | #gets                    | Accepts a new optional keyword argument, `chomp`.
| ✓ |                  | #lines                   |         |
| ✓ |                  | #readline                |         |
| ✓ |                  | #readlines               |         |
| ✓ |                  | .readlines               | Accepts a new optional keyword argument, `chomp`.
| ✓ | IPAddr           | #==                      | No longer raises an exception if coercion fails.
| ✓ |                  | #<=>                     | No longer raises an exception if coercion fails.
| ✗ | Kernel           | #send                    | Supports refined methods.
| ✗ | Logger           | #new                     |         |
| ✓ | MatchData        | #named_captures          |         |
| ✓ |                  | #values_at               | Supports named captures.
| ✗ | Module           | #refine                  | Accepts a module as an argument.
| ✗ |                  | .used_modules            |         |
| ✗ | Net::HTTP        | #post                    | New
| ✗ | Net::FTP         | #new                     | Supports hash style options.
| ✗ |                  | #status                  | Accepts a new optional keyword argument, `pathname`.
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
| ✗ | REXML::Element   | #[]                      | If `String` or `Symbol` is specified, attribute value is returned. Otherwise, Nth child is returned.
| ✗ | Rational         | #round                   |         |
| ✓ | Regexp           | #match?                  | New
| ✗ | Set              | #compare_by_identity     | New
| ✗ |                  | #compare_by_identity?    | New
| ✗ | String           | #capitalize              | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #capitalize!             | Supports Unicode and accepts several new keyword arguments.
| P |                  | #casecmp?                | New (Does not support Unicode characters.)
| ✓ |                  | #concat                  | Now accepts multiple arguments.
| ✗ |                  | #downcase                | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #downcase!               | Supports Unicode and accepts several new keyword arguments.
| ✓ |                  | #each_line               | Accepts a new optional keyword argument, `chomp`.
| ✓ |                  | #lines                   | Accepts a new optional keyword argument, `chomp`.
| ✓ |                  | #match?                  |         |
| P |                  | .new                     | Accepts a new optional keyword argument, `capacity`. (Allows `:capacity` option to pass but does nothing.)
| ✓ |                  | #prepend                 | Now accepts multiple arguments.
| ✗ |                  | #swapcase                | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #swapcase!               | Supports Unicode and accepts several new keyword arguments.
| ✓ |                  | #unpack1                 |         |
| ✗ |                  | #upcase                  | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #upcase!                 | Supports Unicode and accepts several new keyword arguments.
| ✓ | StringIO         | #each_line               | Accepts a new optional keyword argument, `chomp`.
| ✓ |                  | #gets                    | Accepts a new optional keyword argument, `chomp`.
| ✓ |                  | #readline                | Accepts a new optional keyword argument, `chomp`.
| ✓ |                  | #readlines               | Accepts a new optional keyword argument, `chomp`.
| ✗ | Symbol           | #capitalize              | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #capitalize!             | Supports Unicode and accepts several new keyword arguments.
| P |                  | #casecmp?                | New (Does not support Unicode characters.)
| ✗ |                  | #downcase                | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #downcase!               | Supports Unicode and accepts several new keyword arguments.
| ✓ |                  | #match                   |         |
| ✓ |                  | #match?                  |         |
| ✗ |                  | #swapcase                | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #swapcase!               | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #to_proc                 |         |
| ✗ |                  | #upcase                  | Supports Unicode and accepts several new keyword arguments.
| ✗ |                  | #upcase!                 | Supports Unicode and accepts several new keyword arguments.
| ✗ | Thread           | #report\_on\_exception   |         |
| ✗ |                  | .report\_on\_exception   |         |
| ✗ | TracePoint       | #callee_id               |         |
| ✗ | Warning          | #warn                    | New

### 2.3

✓ = Implemented, ✗ = Not Implemented, P = Partially Implemented

|   | Object                  | Method                   | Changes |
|:-:| ----------------------- | ------------------------ | ------- |
| ✗ | ARGF                    | #read_nonblock           | Accepts a new optional keyword argument, `exception`.
| ✗ | Array                   | #bsearch_index           |         |
| ✓ |                         | #dig                     | New
| ✗ |                         | #flatten                 | No longer calls `to_ary` on elements beyond the given level.
| ✗ |                         | #flatten!                | No longer calls `to_ary` on elements beyond the given level.
| ✗ |                         | #inspect                 | No longer raises an error if its content returns a string which is not compatible with `Encoding.default_external`.
| ✗ |                         | #pack                    | Add `j` and `J` directives for pointer width integer type.
| ✗ | Base64                  | .urlsafe_encode64        | Accepts a new optional keyword argument, `padding`.
| ✗ |                         | .urlsafe_decode64        | Accepts a new optional keyword argument, `padding`.
| ✗ | BasicSocket             | #recv                    | Allow an output `String` buffer argument.
| ✗ |                         | #recv_nonblock           | Allow an output `String` buffer argument.
| ✗ |                         | #recvmsg_nonblock        | Accepts a new keyword argument, `exception`.
| ✗ |                         | #sendmsg_nonblock        | Accepts a new keyword argument, `exception`.
| ✗ | Comparable              | #==                      | No longer rescues exceptions.
| ✗ | Coverage                | .peek_result             | New
| ✗ | Enumerable              | #chunk                   | No longer accepts the `initial_state` keyword argument.
| ✓ |                         | #chunk_while             |         |
| ✓ |                         | #grep_v                  | New
| ✓ |                         | #slice_before            | No longer accepts the `initial_state` keyword argument.
| ✓ | Enumerator::Lazy        | #grep_v                  | New
| ✗ | File                    | .mkfifo                  |         |
| ✗ | File::Stat              | #ino                     | On Windows, it always returned `0`, but now returns `BY_HANDLE_FILE_INFORMATION.nFileIndexHigh/Low`.
| ✗ | Hash                    | #<                       |         |
| ✗ |                         | #<=                      |         |
| ✗ |                         | #>                       |         |
| ✗ |                         | #>=                      |         |
| ✓ |                         | #dig                     | New
| ✓ |                         | #fetch_values            |         |
| ✗ |                         | #inspect                 | No longer raises an error if its content returns a string which is not compatible with `Encoding.default_external`.
| P |                         | #to_proc                 | New (Works in every respect but returns a `lambda` instead of a `proc`. Returning a `proc` may be an error in MRI's implementation. See: https://bugs.ruby-lang.org/issues/12671)
| ✗ | IO                      | #advise                  | No longer raises Errno::ENOSYS in cases where it was detected at build time but not available at runtime.
| ✗ |                         | #close                   | Doesn't raise when the IO object is closed.
| ✗ |                         | #each_codepoint          | Raises an exception at incomplete character before EOF when conversion takes place.
| ✗ |                         | #wait_readable           | No longer checks FIONREAD.
| ✓ | Kernel                  | #loop                    | When stopped by a StopIteration exception, returns what the enumerator has returned instead of nil.
| ✗ | Logger                  | #level=                  |         |
| ✗ |                         | #reopen                  | New
| ✗ | Module                  | #define_method           | Now requires a method body, `Proc`, `Method`, or a block.
| ✗ |                         | #deprecate_constant      |         |
| ✗ | NameError               | #receiver                | New
| ✗ | Net::FTP                | .default_passive=        | New
| ✗ |                         | #mlst                    | New
| ✗ |                         | #mlsd                    | New
| ✗ | Net::HTTP               | #open_timeout            | Now has a default value of `60`.
| ✓ | Numeric                 | #negative?               | New
| ✓ |                         | #positive?               | New
| ✗ | Object                  | #define_singleton_method | Now requires a method body, `Proc`, `Method`, or a block.
| ✗ |                         | #timeout                 | Warns that it is deprecated.
| ✗ | ObjectSpace             | .count_symbols           | New
| ✗ |                         | .count_imemo_objects     | New
| ✗ |                         | .internal_class_of       | New
| ✗ |                         | .internal_super_of       | New
| ✗ | OpenSSL::SSL::SSLSocket | #accept_nonblock         | Accepts a new keyword argument, `exception`.
| ✗ |                         | #connect_nonblock        | Accepts a new keyword argument, `exception`.
| ✗ | Pathname                | #ascend                  |         |
| ✗ |                         | #descend                 |         |
| ✗ | Queue                   | #close                   |         |
| ✗ | Socket                  | #accept_nonblock         | Accepts a new keyword argument, `exception`.
| ✗ |                         | #connect_nonblock        | Accepts a new keyword argument, `exception`.
| ✓ | String                  | #+@                      | New
| ✓ |                         | #-@                      | New
| ✓ |                         | .new                     | Accepts a new keyword argument, `encoding`.
| ✗ |                         | #unpack                  | Add `j` and `J` directives for pointer width integer type.
| ✗ | StringIO                | #set_encoding            | No longer sets the encoding of its buffer string.
| ✓ | Struct                  | #dig                     | New
| ✗ | TCPServer               | #accept_nonblock         | Accepts a new keyword argument, `exception`.
| ✗ | Thread                  | #name                    | New
| ✗ |                         | #name=                   | New
| ✗ | UNIXServer              | #accept_nonblock         | Accepts a new keyword argument, `exception`.
| ✗ | Vector                  | #round                   | New

### 2.2

✓ = Implemented, ✗ = Not Implemented, P = Partially Implemented

|   | Object      | Method                                  | Changes |
|:-:| ----------  | --------------------------------------- | ------- |
| ✗ | Binding     | #local_variables                        | New
| ✗ |             | #receiver                               | New
| ✗ | Dir         | #fileno                                 | New
| ✓ | Enumerable  | #max                                    | Accepts a new optional argument to return multiple elements.
| ✓ |             | #max_by                                 | Accepts a new optional argument to return multiple elements.
| ✓ |             | #min                                    | Accepts a new optional argument to return multiple elements.
| ✓ |             | #min_by                                 | Accepts a new optional argument to return multiple elements.
| ✓ |             | #slice_after                            | New
| ✓ |             | #slice_when                             | New
| ✗ | Etc         | .confstr                                | New
| ✗ |             | .sysconf                                | New
| ✗ |             | .nprocessors                            | New
| ✗ |             | .uname                                  | New
| ✗ | Float       | #next_float                             | New
| ✗ |             | #prev_float                             | New
| ✗ | File        | .birthtime                              | New
| ✗ |             | #birthtime                              | New
| ✗ | File::Stat  | #birthtime                              | New
| ✗ | Find        | .find                                   | Accepts a new optional keyword argument, `ignore_error`.
| ✗ | GC          | .latest_gc_info                         |         |
| ✗ |             | .stat                                   |         |
| ✗ | IO          | #each_codepoint                         |         |
| ✗ |             | #nonblock_read                          | Supports pipes on Windows.
| ✗ |             | #nonblock_write                         | Supports pipes on Windows.
| ✗ |             | #pathconf                               | New
| ✓ | Kernel      | #itself                                 | New
| ✗ |             | #throw                                  | Raises `UncaughtThrowError`, subclass of `ArgumentError` when there is no corresponding catch block, instead of `ArgumentError`.
| ✗ | Math        | .atan2                                  | Now returns values like as expected by C99 if both two arguments are infinity.
| ✗ |             | .log                                    | Now raises `Math::DomainError` instead of returning `NaN` if the base is less than 0, and returns `NaN` instead of -infinity if both of two arguments are 0.
| ✗ | Matrix      | #+@                                     | New
| ✗ |             | #-@                                     | New
| ✗ |             | #adjugate                               | New
| ✗ |             | #cofactor                               | New
| ✗ |             | #first_minor                            | New
| ✗ |             | .hstack                                 | New
| ✗ |             | #hstack                                 | New
| ✗ |             | #laplace_expansion                      | New
| ✗ |             | .vstack                                 | New
| ✗ |             | #vstack                                 | New
| ✗ | Method      | #curry                                  | New
| ✗ |             | #super_method                           | New
| ✗ | ObjectSpace | .memsize_of                             |         |
| ✗ | Pathname    | #/                                      | New (alias of `#+`)
| ✗ |             | #birthtime                              | New
| ✗ |             | #find                                   | Accepts a new optional keyword argument, `ignore_error`.
| ✗ | Prime       | .prime?                                 | Now returns `false` for negative numbers.
| ✗ | Process     | .spawn                                  |         |
| ✗ | String      | #unicode_normalize                      | New
| ✗ |             | #unicode_normalize!                     | New
| ✗ |             | #unicode_normalized?                    | New
| ✗ | Time        | .httpdate                               |         |
| ✗ |             | .parse                                  | May produce fixed-offset `Time` objects.
| ✗ |             | .rfc2822                                | May produce fixed-offset `Time` objects.
| ✗ |             | .strptime                               | May produce fixed-offset `Time` objects. Raises `ArgumentError` when there is no date information.
| ✗ |             | .xmlschema                              | May produce fixed-offset `Time` objects.
| ✗ | TSort       | .each_strongly_connected_component      | Returns an enumerator if no block is given.
| ✗ |             | .each_strongly_connected_component_from | Returns an enumerator if no block is given.
| ✗ |             | .tsort_each                             | Returns an enumerator if no block is given.
| ✓ | Vector      | #+@                                     | New
| ✗ |             | #-@                                     | New
| ✗ |             | #angle_with                             | New
| ✗ |             | .basis                                  | New
| ✗ |             | #cross                                  | New (alias of `#cross_product`)
| ✗ |             | #cross_product                          | New
| ✗ |             | #dot                                    | New (alias of `#inner_product`)
| ✗ |             | .independent?                           | New
| ✗ |             | #independent?                           | New

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AaronLasseigne/polyfill.
Please read the [contributing file](CONTRIBUTING.md) prior to pull requests.

## Credits

Polyfill is licensed under the [MIT License](LICENSE.txt).
