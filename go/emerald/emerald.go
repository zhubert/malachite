package emerald

import "encoding/json"

import "C"

type Data *C.char

func Unmarshal(data Data, v interface{}) error {
	err := json.Unmarshal([]byte(C.GoString(data)), &v)
	return err
}

func Error(err error) Data {
	return C.CString(err.Error())
}

func Marshal(v interface{}) Data {
	b, err := json.Marshal(v)
	if err != nil {
		return C.CString("{}")
	}
	return C.CString(string(b))
}
