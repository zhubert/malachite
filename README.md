### Emerald

A RubyGem and Go Package which enables calling Go code from Ruby.


### Write a Go Shared Object


```go
package main

import "strings"
import "github.com/zhubert/emerald/go/emerald"
import "C"

//export upcase
func upcase(data *C.char) *C.char {
	things := []string{}
	err := emerald.Unmarshal(data, &things)
	if err != nil {
		return emerald.Error(err)
	}
	upperCased := []string{}
	for _, thing := range things {
		upperCased = append(upperCased, strings.ToUpper(thing))
	}
	return emerald.Marshal(upperCased)
}

func main() {}
```

Finally, make it into a .so via:

    go build -buildmode=c-shared -o libfoo.so libfoo.go

### Invocation in Ruby



```ruby
client = Emerald::Client.new(file_path: 'upcase.go')

```
