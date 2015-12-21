Or if you have more interesting data organize it with a struct:

```go
package main

import "strings"

type Person struct {
	Name string `json:"name"`
	Age  string `json:"age"`
}

func HandleStructured(people []Person) (upperCasedPeople []Person) {
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
=> [{"name"=>"PETER", "age"=>"27"}, {"name"=>"TIM", "age"=>"30"}]
```
