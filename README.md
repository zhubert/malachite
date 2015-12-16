### Emerald

A RubyGem and Go Package which enables calling Go code from Ruby.

### Write a Go Function

Thanks to some code villainy, you can just write a normal function.

* it must be called handler
* it can only have one argument

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

### Rails

Make a subdirectory of "app" called "go".

Add this to your Gemfile:

```ruby
gem 'emerald', github: 'zhubert/emerald', branch: 'zhubert/crazy'
```

Then use your function from Rails:

```ruby
Emerald::Client.upcase(["foo","bar"])
```

Emerald will assume you have a file named `upcase.go`, which has the code from the Go example above.
