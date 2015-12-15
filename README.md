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

Gemfile:

```ruby
gem 'emerald', github: 'zhubert/emerald'
```
Assuming you put things into "app/go" and want to go with a more Railsy approach:

```ruby
Emerald::Client.upcase(["foo","bar"])
```

Emerald will assume you have a file named `upcase.go`.

Or if you want more control...

```ruby
go_file = Rails.root.join('app', 'go', 'upcase.go')
c = Emerald::Client.new(go_file.to_s)
c.call(["foo", "bar"])
```
