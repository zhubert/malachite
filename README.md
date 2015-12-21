### Malachite

A RubyGem which enables calling Go code from Rails.

### Installation

Install [Go 1.5 or later](https://golang.org/doc/install) on relevant machines.

Add this to your Gemfile:

```ruby
gem 'malachite'
```

Make a subdirectory of "app" called "go".

### Write Some Go Functions

Everything in ```app/go```will get compiled into one namespace, so to get it to work with
Malachite, you need to:

* name the methods you want exported like: ```HandleFoo```
* the Handle methods can only take one argument (use [structs](https://github.com/zhubert/malachite/wiki/Structs) for more complexity)

For instance, if you wanted to upcase strings more quickly in your Rails app, you'd put the following in the file ```app/go/upcase.go```:

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

### Testing

I'd encourage writing tests for your Go code in the usual fashion. ```app/go/upcase_test.go``` would be the right place for it in the example above.

Slightly more detail found in [Testing](https://github.com/zhubert/malachite/wiki/Testing)

### How Does it Work?

One part code generation, another part pure evil.

* The first time the function is called, Malachite will build a shared library from all the Go code in your ```app/go``` folder
* It then uses Ruby's Fiddle to call the shared library
* Arguments are passed back and forth via JSON

Because of the JSON step, you'll only see real performance gains on computationally difficult tasks. Ruby's JSON conversion is a large tax.

### Ruby 2.2.4+

It's strongly recommended to use the [newest release of Ruby](https://www.ruby-lang.org/en/news/2015/12/16/unsafe-tainted-string-usage-in-fiddle-and-dl-cve-2015-7551/) as there was a security issue with older versions of Fiddle.
