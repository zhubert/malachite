Or even something totally arbitrary:

```go
package main

import "strings"

type Person struct {
	Name string `json:"name"`
}

type Foo struct {
	Friends []Person `json:"friends"`
	Enemies []Person `json:"enemies"`
}

func HandleFrenemies(foo Foo) (frenemies []Person) {
	for _, friend := range foo.Friends {
		for _, enemy := range foo.Enemies {
			if friend.Name == enemy.Name {
				frenemies = append(frenemies, friend)
			}
		}
	}
	return
}
```

```ruby
friends = [{name: 'Peter'},{name: 'Tim'}]
enemies = [{name: 'Peter'},{name: 'Zeb'}]
Malachite::Client.frenemies({friends: friends, enemies: enemies})
=> [{"name"=>"Peter"}]
```
