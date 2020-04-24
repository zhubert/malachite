### Malachite

Call Go functions directly from Rails.


### Requirements

Requires Ruby >= 2.0.0, Go 1.5+.


### Installation

Install [Go](https://golang.org/doc/install). You must have a proper GOPATH.

Add this to your Gemfile:

```ruby
gem 'malachite'
```

### Write Some Go Functions

Everything in ```app/go``` will get compiled into one library, so to get it to work with
Malachite, you need to:

* name the methods you want exported like: ```HandleFoo```
* the Handle methods can only take one JSON-serializable argument, works best with arrays or [structs](https://github.com/zhubert/malachite/wiki/Structs)

For instance, if you wanted to upcase strings, you'd put the following in ```app/go/upcase.go```:

```go
package main

import (
	"strings"
)

func HandleUpcase(things []string) (upperCased []string) {
	for _, thing := range things {
		upperCased = append(upperCased, strings.ToUpper(thing))
	}
	return
}
```

Then use your function from Rails:

```ruby
Malachite.upcase(["foo","bar"])
=> ["FOO", "BAR"]
```

More examples can be found in [examples](https://github.com/zhubert/malachite/wiki/Examples).

Note: This would actually be slower than doing it in Ruby, due to the JSON serialization.


### Testing

Check out the wiki on [Testing](https://github.com/zhubert/malachite/wiki/Testing)

### How Does it Work?

Code generation.

* On every load in development and one time on boot elsewhere, Malachite will build a shared library from all the Go code in your ```app/go``` folder
* It then uses Ruby's Fiddle to call the shared library
* Arguments are passed back and forth via JSON

Because of the JSON step, you'll only see real performance gains on computationally difficult tasks. Ruby's JSON conversion is a large tax.


### Ruby 2.2.4+

It's strongly recommended to use the [newest release of Ruby](https://www.ruby-lang.org/en/news/2015/12/16/unsafe-tainted-string-usage-in-fiddle-and-dl-cve-2015-7551/) as there was a security issue with older versions of Fiddle.
