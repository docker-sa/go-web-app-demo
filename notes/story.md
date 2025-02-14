https://docs.docker.com/compose/

## 01 Intro: the application

- I'm working on a web application to provide a list of excellent restaurants in Paris (for my non-French colleagues)

Let me present this application:

**📝🟨 go to /notes/00-application.md** and Explain


## 02 Dockerizing the application

When you "Dockerize" an application:
- You will package the application and its dependencies into a Docker Image
- With this image, you will be able to run your application in a container
- Then you can make your application portable and run it everywhere in the same way.
- And you can reproduce this easily.

### Let's start with a Dockerfile.

> *I need a Dockerfile to "dockerize" or to package the application with all its dependencies*

<!-- ✋ simplify the text -->

A Dockerfile is a script with instructions on how to build a Docker image.

The Dockerfile is like a recipe to specify what you will put into the image (the file system, the application binary, the dependencies and so on...)

**📝🟨 go to /notes/01-dockerize.md**

- Copy the content of the Dockerfile
- Explain


### Now, I need a Compose file.

> *A Compose file is a yaml file to define and manage multi-container applications; Docker Compose will use it.*

> *Then Docker Compose will help to orchestrate the services needed to run my project: the redis database and my web application*

- Copy the content of the Compose file
- Explain: we have two services ...


### First Start of the project

*It's time to start our project*

```bash
docker compose up
```

- Explain the output in the terminal
- Go to **DD**
- Show the containers
- Enter into the redis one: 🔴 create the data 🔴
  
  - **Files Panel** -> Show the content of the scripts
  - **Exec Panel** -> Create the data: cd /scripts
- 🌍 **Containers list** -> Run and show the web app: http://localhost:8080

		
*Now, we stop the compose project, and we will activate the watch mode*

```bash
docker compose down
```

### Activate the **watch mode** 

- Explain in the compose file
```bash
docker compose watch
```
- Change something



- Change something in `info.txt`
- Save
- Refresh

### In Docker Desktop GUI: Let's have a look at the "Images" panel (+ "Builds" panel)

- Select the **paris-restaurants** image.
- **Show the size** (it's a lot)
- **Go to the builds panel FIRST (✋ waiting for the scout scanning)**

- **Go to the image view**
- And we have a lot of vulnerabilities.
- On the right, it's the **Docker Scout** View
  - Docker Scout is a container vulnerability scanner 
  - You can use it as a CLI, locally or with your CI/CD system

#### First, let's try to fix the vulnerabilities.

=> **Go to the recommended fixes and apply them.**

```Dockerfile
FROM golang:1.22-alpine
```

- Go to the images panel.
- Show the **size** of the image (👍 better)
- **Show again the build and the history of the build**

- Show the vulnerabilities (no more vulnerability 🎉)


#### Let's try to be better with the size.

> *I can do better with the size of the image*

I will create a **build pipeline** into the Dockerfile, with two steps (or two stages), one for the build and one for making a final image smaller. We call this multi stage build

**==Snippets:==** 🔴 EXPLAIN 🔴
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY main.go .
COPY go.mod .

RUN <<EOF
go mod tidy 
go build -o tiny-service
EOF

FROM alpine:3.19
WORKDIR /app
COPY --from=builder /app/tiny-service .

COPY public ./public 
CMD ["./tiny-service"]
```

- Go to the images panel.
- Show the **size** of the image (👍 better)
- **Show again the build and the history of the build**


#### We can do even better with a distroless image or with a scratch image

> A distroless image is a minimal Docker image that includes only the essential components needed to run the application without a complete operating system, thereby reducing the attack surface and image size.

**==Snippets:==**
```dockerfile
FROM gcr.io/distroless/static-debian12
```

> A scratch image in Docker is an empty, minimal base image used to build lightweight containers by adding only the necessary files and dependencies.

**==Snippets:==**
```dockerfile
FROM scratch
```

### Let's have a look at the "Builds" panel

👋 show the History panel of the **Build panel**

🔴 Run and show the web app: http://localhost:8080 -> everything is allright


## 03 Docker Debug

- Return to the "**Containers**" panel.
- Try to go to the **"Exec"** panel.
- Explain why it does not work.
> You cannot use `docker exec` with a distroless container because distroless images do not include a shell or common utilities, which are typically required to execute commands inside the container. 

Thankfully, we now have **Docker Debug**.

Docker debug is a CLI tool that "spawns" all **that** you need to execute commands inside a container

```bash
ls
cd public
ls
```

- `nano info.txt` and change the content.
- Refresh the webpage

✋ DO NOT USE 🔴 **📝🟨 go to /notes/02-docker-debug.md**


## 04 Testcontainers

Ok, at this stage, we have an almost complete toolchain for our development.

But the integration and end-to-end tests still need to be included.

For that, we will use **Testcontainers**.

Testcontainers is a framework for provisioning on-demand containers for development and testing use cases

**🔴 GO TO THE SLIDES 🔴**

**📝🟨 go to /notes/03-testcontainers.md**

- Explain
- Run `go tests`

There you go. Our toolchain is now complete.
I can build, test, and deploy my application with confidence.


> *But before talking about deployment, let's talk about multi-architecture build*

✋ **IF NEEDED STOP DOCKER COMPOSE**

## 05 multi-architecture + Bake

**📝🟨 go to /notes/04-docker-bake.md**


Sometimes, we need to provide docker images for several target architectures.
For example, I'm using a MacBook with an arm architecture, but I want to deploy on a kubernetes cluster with an amd architecture.

We can do that thanks to the `buildx` command

👋 **Explain the new Dockerfile**

👋 **Show the docker build command**

This command will eventually become complicated to handle because of the numerous options, especially if you want to do the builds with a CI system.

Another feature of `buildx` is Docker Bake. Bake will simplify the build process and allow you to define the build configuration in a declarative file.

GO TO DOCKER DESKTOP and show the image and the builds

## 06 Docker Build Cloud

EXPLAIN DOCKER BUILD CLOUD:
Docker Build Cloud is a service that helps you create your Docker container images faster. It does this by running the build process on cloud infrastructure, which is optimally set up for your workloads, without you needing to do any configuration.

Think of it like a remote factory that assembles your Docker images.


```bash
docker buildx bake --push --file docker-bake.hcl --builder cloud-demonstrationorg-default
```
Use it a 2nd time with another image:

```Dockerfile
FROM alpine:3.19
```

GO TO DOCKER DESKTOP and show the image and the builds

LAST STEP
## 08 Deploy the application on Kubernetes

I'm not a Kubernetes expert. But I want to verify if my application is Cloud Compliant, and I can do that with Docker Desktop.


When you install Docker Desktop you gain a kubernetes cluster, it`s totally sufficient for testing, experimenting, and verifying.

And it's pretty helpful to learn Kubernetes.

**📝🟨 go to /notes/05-deploy-to-kube.md**

✋ Explain and show the manifest number 04

```bash
# Deploy the service
kubectl apply -f ./04-deploy.app.yaml -n demo

# Check the deployment
kubectl describe ingress demo-accelerate -n demo

# 🌍 open the webapp in the browser: http://accelerate.0.0.0.0.nip.io
```



