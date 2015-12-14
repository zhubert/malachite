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
	"encoding/json"
	"strings"
)
import "C"

//export upcase
func upcase(data *C.char) *C.char {
	things := []string{}
	err := Unmarshal(data, &things)
	if err != nil {
		return Error(err)
	}
	upperCased := []string{}
	for _, thing := range things {
		upperCased = append(upperCased, strings.ToUpper(thing))
	}
	return Marshal(upperCased)
}

func main() {}

// the following needs to be extracted somehow
func Unmarshal(data *C.char, v interface{}) error {
	err := json.Unmarshal([]byte(C.GoString(data)), &v)
	return err
}

func Error(err error) *C.char {
	return C.CString(err.Error())
}

func Marshal(v interface{}) *C.char {
	b, err := json.Marshal(v)
	if err != nil {
		return C.CString("{}")
	}
	return C.CString(string(b))
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
