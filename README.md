### Emerald

A RubyGem and Go Package which enables calling Go code from Ruby.

### TODO

* multiple source files (directories?)
* marshalling helpers instead of go package?
* complex arguments

### Write a Go Shared Object

```go
package main

import (
	"C"
	"strings"

	"github.com/zhubert/emerald/go/emerald"
)

//export upcase
func upcase(data *C.char) *C.char {
	things := []string{}
	err := emerald.Unmarshal(C.GoString(data), &things)
	if err != nil {
		return C.CString(err.Error())
	}
	upperCased := []string{}
	for _, thing := range things {
		upperCased = append(upperCased, strings.ToUpper(thing))
	}
	return C.CString(emerald.Marshal(upperCased))
}

func main() {}
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

Emerald will assume you meant a file named `upcase.go` and an exported method of `upcase`.

Or if you want more control...

```ruby
go_file = Rails.root.join('app', 'go', 'upcase.go')
c = Emerald::Client.new(file_path: go_file.to_s, method: 'upcase')
c.call(["foo", "bar"])
```

### Invocation in Ruby

```ruby
client = Emerald::Client.new(file_path: 'upcase.go', method: 'upcase')
client.call(['foo','bar'])
```
