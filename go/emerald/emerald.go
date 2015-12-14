package emerald

import "encoding/json"

import "C"

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
