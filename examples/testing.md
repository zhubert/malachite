### Testing

Testing your Go code is unchanged from the usual way you do it.

For instance, for the Upcase example, you might make ```app/go/upcase_test.go``` and
then call it via ```rake malachite:test`` or just via ```go test``` as usual.

```go
package main

import "testing"

func TestHandleUpcase(t *testing.T) {
	actual := HandleUpcase([]string{"foo", "bar"})
	if actual[0] != "FOO" || actual[1] != "BAR" {
		t.Error("not uppercased: %v", actual)
	}
}
```
