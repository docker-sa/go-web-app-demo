# "Dockerize" the project

## Dockerfile

```Dockerfile
FROM golang:1.22.4
WORKDIR /app
COPY main.go .
COPY go.mod .

RUN <<EOF
go mod tidy 
go build -o tiny-service
EOF

COPY public ./public 
CMD ["./tiny-service"]
```

## Compose file

```yaml
services:
  redis-server:
    image: redis:7.2.4
    environment: 
      - REDIS_ARGS=--save 30 1
      # snapshot
    ports:
      - 6379:6379
    volumes:
      - ./scripts:/scripts
      - ./data:/data

  webapp:
    build: .
    image: paris-restaurants
    ports:
      - 8080:8080 
    environment:
      - MESSAGE=🎉 Hello from 🐳 Compose 👋
      - TITLE=My favorite restaurants
      - REDIS_URL=redis-server:6379    
    depends_on:
      - redis-server 
    develop:
      watch:
        - action: sync
          path: ./public
          target: /app/public
        - action: rebuild
          path: ./Dockerfile
        - action: rebuild
          path: ./main.go
```

## Actions

- Create the Dockerfile and the Compose file
  - `docker compose up`
  - `docker compose down`
- Run the Docker Compose Stack in **"watch"** mode: `docker compose watch`
- Load data in the Redis database (from the Docker Desktop GUI)
- Let's have a look to the **Images** panel in the Docker Desktop GUI
  - Improve the image size and remove the vulnerabilities
  - Use a multi-stage build

## Smaller image with multi-stage build

```Dockerfile
# `builder` stage
FROM golang:1.22-alpine AS builder 

WORKDIR /app
COPY main.go .
COPY go.mod .

RUN <<EOF
go mod tidy 
go build -o tiny-service
EOF

# `final` stage
FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/tiny-service .

COPY public ./public 
CMD ["./tiny-service"]
```

> We can do even better with a distroless image or with a scratch image
> - A distroless image is a minimal Docker container image that includes only the essential components needed to run an application, without a complete operating system, thereby reducing the attack surface and image size.
>   - `FROM gcr.io/distroless/static-debian12`
> - A scratch image in Docker is an empty, minimal base image used to build lightweight containers by adding only the necessary files and dependencies.
>   - `FROM scratch`

___
[◀️ Previous](./00-application.md) | [Next: Docker Debug ▶️](./02-docker-debug.md)