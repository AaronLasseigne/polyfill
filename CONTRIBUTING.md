## Contributing

1. [Fork](#fork)
2. [Tests](#tests)
3. [Code](#code)
4. [Push and Submit](#push-and-submit)
5. [Refine Until Merged](#refine-until-merged)

### Fork

[Fork](https://github.com/AaronLasseigne/polyfill/fork) the repo.

### Tests

The goal is to produce code that is identical to the real method. One
of the best places to find examples is the
[Ruby Spec Suite](https://github.com/ruby/spec). If tests exist there,
please copy them out and change them from MSpec to RSpec. Newer
methods may not be available in which case you'll have to add your
own tests. If the feature is new then you'll need to test every aspect
of it.

If this is a change that adds to an existing feature make sure to have
a basic test of the old functionality and then test all of the new
functionality.

Looking over an existing test or two should give you an idea of what
to do.

### Code

The directory structure follows the module structure. Files are added
(`require` and `include`) one directly level up from their location.
This help keep everything segmented and stops there from being a
single top level file with a ton of `require` statements.

The structure is formulaic so looking through an existing example
or two should clarify what to do. If you're not sure how to proceed,
please reach out and we'll figure it out.

Partial implementations of features are welcome as long as they
bring value. Generally it's only ok to leave out part of the feature
when that part is very hard and/or secondary to the primary 
functionality. What constitutes "value", "hard", and what gets
accepted may seem a bit arbitrary. If you're unsure, please reach out
and we'll discuss. I'd hate to see a bunch of work done only to get
rejected.

### Push and Submit

Push your branch up to your fork. Submit a pull request via
GitHub.

### Refine Until Merged

There are weird edge cases and particulars that might need to be
changed. Don't worry if you get a lot of comments on your pull
request. That's why we have code reviews. People miss things and more
eyes catch more issues. After everything is fixed: VICTORY!
