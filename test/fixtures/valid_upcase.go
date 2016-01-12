package main

// #cgo darwin LDFLAGS: -Wl,-undefined -Wl,dynamic_lookup
// #cgo !darwin LDFLAGS: -Wl,-unresolved-symbols=ignore-all
// #cgo CFLAGS: -IHEADER/ -IARCH/
// #include <stdlib.h>
// #include "ruby/ruby.h"
import "C"

import (
	"strings"
)

func HandleUpcase(things []string) (upperCased []string) {
	for _, thing := range things {
		upperCased = append(upperCased, strings.ToUpper(thing))
	}
	return
}

//export callUpcase
func callUpcase(data *C.char) C.VALUE {
	things := []string{}
	err := Unmarshal(C.GoString(data), &things)
	if err != nil {
		str := err.Error()
		cstr := GOSTRING_PTR(str)
		return C.rb_utf8_str_new(cstr, C.long(len(str)))
	} else {
		str := Marshal(HandleUpcase(things))
		cstr := GOSTRING_PTR(str)
		return C.rb_utf8_str_new(cstr, C.long(len(str)))
	}
}
