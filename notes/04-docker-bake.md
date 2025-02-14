# Multi-architecture images

## Docker Buildx and Multi Architecture builds

Docker Buildx was designed to bring the advanced build features from the Moby BuildKit project into Docker as a Docker CLI plugin. 

> ✋ **check "Use containerd for pulling and storing images" in DD**

In simpler terms, Docker Buildx lets you:

- **Build images for different CPU architectures**: 
  - like `AMD64`, `ARM64`, etc.
- **Utilize advanced build features**: 
  - It leverages BuildKit, which enhances the building process with features like efficient handling of **large numbers of files** and **parallel builds**.
- **Create a single image that works on multiple architectures**: 
  - Known as a **`"multi-architecture image"`**, this is great for distribution since users can pull the same image name and get the appropriate architecture for their system automatically.


---

For example, I want to build a **multi-architecture** image for my Golang application. 

## Update the Dockerfile

```Dockerfile
# ✋ BUILDPLATFORM is a build argument that specifies the platform where the image is built.
FROM --platform=$BUILDPLATFORM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
COPY go.mod .

# ✋ TARGETOS and TARGETARCH are passed as build arguments.
ARG TARGETOS
ARG TARGETARCH

RUN <<EOF
go mod tidy 
# ✋ GOOS and GOARCH are set to the build arguments, so the binary is built for the target platform.
GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o tiny-service
EOF

FROM scratch
WORKDIR /app
COPY --from=builder /app/tiny-service .

COPY public ./public 
CMD ["./tiny-service"]

# docker buildx build \
#  --platform=linux/amd64,linux/arm64 \
#  --push -t philippecharriere494/paris-restaurants:0.0.1 .
```

## Docker Build

```bash
docker buildx build \
--platform=linux/amd64,linux/arm64 \
--push -t philippecharriere494/paris-restaurants:0.0.1 .
```

## Docker Bake & Bake file

Docker Bake is a feature of Docker Buildx that simplifies the process of building Docker images. It allows you to define your build configuration in a **declarative file**, instead of specifying a complex command-line expression. This makes it easier to manage your build configuration and share it with your team.


```json
variable "REPO" {
  default = "philippecharriere494"
}

variable "TAG" {
  default = "0.0.1"
}

group "default" {
  targets = ["paris-restaurants-image"]
}

target "paris-restaurants-image" {
  context = "."
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
  tags = ["${REPO}/paris-restaurants:${TAG}"]
}

# docker buildx bake --push --file docker-bake.hcl
```

### Build the image with the `bake` command:

```bash
docker buildx bake --push --file docker-bake.hcl
```
<!--
docker buildx ls
docker login
docker buildx bake --push --file docker-bake.hcl
-->

👀 See: https://hub.docker.com/repository/docker/philippecharriere494/paris-restaurants/general


## Bake with Docker Build Cloud

**Docker Build Cloud** is a service that helps you create your Docker container images faster. It does this by running the build process on cloud infrastructure, which is optimally set up for your workloads, without you needing to do any configuration. 

Think of it like a **remote factory** that assembles your Docker images.

You can use Docker Build Cloud in the same way you would run a regular build, using the `docker buildx build` command. The difference is that the build gets executed in the cloud, not on your local machine. 

Docker Build Cloud also provides several benefits over local builds, including improved build speed, shared build cache, and native multi-platform builds. 

For more information, you can refer to the [official Docker documentation](https://docs.docker.com/build-cloud/).


> Use it with Docker Bake:
```bash
docker buildx bake --push --file docker-bake.hcl --builder cloud-demonstrationorg-default
```

___
[◀️ Previous](./03-testcontainers.md) | [Next: Deploy on K8S ▶️](./05-deploy-to-kube.md)


