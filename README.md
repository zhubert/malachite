### Malachite

A RubyGem which enables calling Go code from Rails.

### Installation

Install [Go 1.5 or later](https://golang.org/doc/install) on relevant machines.

Add this to your Gemfile:

```ruby
gem 'malachite', github: 'zhubert/malachite'
```

Make a subdirectory of "app" called "go".

### Write a Go Function

You can just write a normal function with some "opinionated" requirements:

* it must be called Handler
* it can only have one argument

For instance, if you wanted to upcase strings more quickly in your Rails app, you'd put the following in the file "app/go/upcase.go":

```go
package main

import (
	"strings"
)

func Handler(things []string) (upperCased []string) {
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
Or if you have more interesting data.

```go
package main

import "strings"

type Person struct {
	Name string `json:"name"`
	Age  string `json:"age"`
}

func Handler(people []Person) (upperCasedPeople []Person) {
	for _, person := range people {
		upCase := Person{strings.ToUpper(person.Name), person.Age}
		upperCasedPeople = append(upperCasedPeople, upCase)
	}
	return
}
```

```ruby
peeps = [{name: 'Peter', age: '27'},{name: 'Tim', age: '30'}]
Malachite::Client.structured(peeps)
```
### How Does it Work?

Some code trickery, quite honestly.

* The first time the function is called, Malachite will build a shared library from your Go code
* Your Go code gets "extended" with a boilerplate template, similar to a generator in Rails
* It then uses Ruby's Fiddle to call the shared library
* Arguments are passed back and forth via JSON

### Ruby 2.2.4+

It's strongly recommended to use the [newest release of Ruby](https://www.ruby-lang.org/en/news/2015/12/16/unsafe-tainted-string-usage-in-fiddle-and-dl-cve-2015-7551/) as there was a security issue with older versions of Fiddle.

### TODO

* Support arbitrary structs
* Rake task to run corresponding go tests
* Error handling
* Benchmark performance...roughly
