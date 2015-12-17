### Malachite

A RubyGem which enables calling Go code from Rails.

### Installation

Add this to your Gemfile:

```ruby
gem 'malachite', github: 'zhubert/malachite'
```

Make a subdirectory of "app" called "go".

### Write a Go Function

Thanks to some code villainy, you can just write a normal function with some "opinionated" requirements:

* it must be called handler
* it can only have one argument

For instance, if you wanted to upcase strings more quickly in your Rails app, you'd put the following in the file "app/go/upcase.go":

```go
package main

import (
	"strings"
)

func handler(things []string) (upperCased []string) {
	for _, thing := range things {
		upperCased = append(upperCased, strings.ToUpper(thing))
	}
	return
}
```

Then use your function from Rails:

```ruby
Malachite::Client.upcase(["foo","bar"])
=> ["FOO", "BAR"]
```

### How Does it Work?

Villainy.

* First time function is called, Malachite will build a shared library from your Go code
* Your Go code gets "extended" with a boilerplate template, similar to a generator in Rails (so you don't have to write the serialization crap over and over)
* It then uses Ruby's Fiddle to call the shared library

### Ruby 2.2.4+

It's strongly recommended to use the [newest release of Ruby](https://www.ruby-lang.org/en/news/2015/12/16/unsafe-tainted-string-usage-in-fiddle-and-dl-cve-2015-7551/) as there was a security issue with older versions of Fiddle.

### TODO

* Support arbitrary structs
* Rake task to run corresponding go tests
* Error handling
* Benchmark performance...roughly
