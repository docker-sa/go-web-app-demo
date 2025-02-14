# Testcontainers

> https://testcontainers.com/

Testcontainers is a framework for provisioning, on-demand containers for development and testing use cases. 
Testcontainers make it easy to work with databases, message brokers, web browsers, or just about anything that can run in a Docker container.

You can also use Testcontainers libraries for local development. Testcontainers libraries are available for most of the popular languages like Java, **Go**, .NET, Node.js, Python, Ruby, Rust, Clojure, and Haskell.

## I want to:
### 1. Start a new Redis container for testing
### 2. Add data to the Redis database
### 3. Run some tests

___
✋ Thanks to **the `testcontainers-go` and the `redisModule` packages**, I can easily start a Redis container and run some tests against it:
#### Start a new Redis container


```golang
redisContainer, err := redisModule.RunContainer(ctx, testcontainers.WithImage("redis:7.2.4"))
require.NoError(t, err)

endpoint, err := redisContainer.Endpoint(ctx, "")
require.NoError(t, err)

rdb := redis.NewClient(&redis.Options{
    Addr: endpoint,
})
```

<!--
> - The code starts a Redis container using the `testcontainers` library.
> - It retrieves the endpoint (address) of the running Redis container.
> - It creates a Redis client configured to connect to the Redis server at the retrieved endpoint.
> - The `require.NoError` assertions ensure that the test fails if there are any errors in starting the container or retrieving the endpoint.
-->

#### Add data to the Redis database

```golang
restaurants := []Restaurant{
    {ID: "1", Name: "Restaurant A", Address: "123 Main St", Website: "https://a.com", Phone: "123-456-7890", Tags: "Italian"},
    {ID: "2", Name: "Restaurant B", Address: "456 Elm St", Website: "https://b.com", Phone: "987-654-3210", Tags: "Mexican"},
}

for _, r := range restaurants {
    rdb.HSet(ctx, "restaurant:"+r.ID, map[string]interface{}{
        "name":    r.Name,
        "address": r.Address,
        "website": r.Website,
        "phone":   r.Phone,
        "tags":    r.Tags,
    })
}
```

#### Test some functions

```golang
	restaurant, err := getRestaurant(ctx, rdb, "2")
	assert.NoError(t, err)
	assert.Equal(t, "Restaurant B", restaurant.Name)
```

```golang
	restaurants, err = getAllRestaurants(ctx, rdb)
	assert.NoError(t, err)
	assert.Len(t, restaurants, 2)
```

And then, I can run my tests: `go test`

or, one by one:

```bash
go test -run TestGetRestaurant
go test -run TestGetAllRestaurants
```

The tests will run:
- `TestGetRestaurant` to check if the restaurants are correctly retrieved from the Redis database
- `TestGetAllRestaurants` to check if all the restaurants are correctly retrieved from the Redis database

## 👏 The toolchain is now complete.
🚀 Let's deploy build the image with Docker Bake.
___
[◀️ Previous](./02-docker-debug.md) | [Next: Bake & Multi Architecture builds ▶️](./04-docker-bake.md)

