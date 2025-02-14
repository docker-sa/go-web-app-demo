# Deploy to Kubernetes

## First, build and publish the image on the Hub

> ✋✋✋ **change the tag of the image if you want to publish the last version of the application on the Hub**

```bash
docker buildx build \
--push -t philippecharriere494/paris-restaurants:0.0.1 .
```
👀 See: https://hub.docker.com/repository/docker/philippecharriere494/paris-restaurants/general

> 👋 the Redis database is already deployed + data

## Checks the K8S cluster connection

```bash
kubectl config get-contexts
# To switch to the docker-desktop context, use:
kubectl config use-context docker-desktop
# Verify
kubectl cluster-info
```

## Start K9S

```bash
k9s --all-namespaces
```

## Deploy the Web Application

- ✋ **show the manifest**
- 👋🔺🔺🔺 **Change the tag of the image**


```bash
# Deploy the service
kubectl apply -f ./04-deploy.app.yaml -n demo

# Check the deployment
kubectl describe ingress demo-accelerate -n demo

# 🌍 open the webapp in the browser: http://accelerate.0.0.0.0.nip.io

# Change the number of replicas for demo-accelerate and apply again
# Then refresh the page (several times)

# Change the environment variable (MESSAGE) and apply again
# Then refresh the page
```

## 🎉🎉🎉 Congratulations! You have deployed the application on Kubernetes!

> Soon: [*[🚀 Early Access]* Compose Bridge](https://docs.docker.com/compose/bridge/)


## Requirements

- A Kubernetes cluster (e.g., Docker Desktop, Minikube, or a cloud provider)
- `kubectl` installed and configured to access the cluster
- `k9s` installed to manage the cluster
- `helm` installed to deploy the application
- Traefik installed to expose the application to the outside world
- The application image published on Docker Hub

### Install Traefik

```bash
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik
```


### Create a demo namespace

```bash
# Create a namespace
kubectl create namespace demo --dry-run=client -o yaml | kubectl apply -f -
```


### Deploy Redis

```bash
kubectl apply -f ./01-deploy.redis.yaml -n demo
```

### Load data into Redis

```bash
kubectl apply -f ./02-create.configmap.yaml -n demo
kubectl apply -f ./03-create.redis.client.pod.cli.yaml -n demo

# We do not need this part anymore:
# Run the script from the redis-client pod to load the data into Redis
#kubectl exec redis-client -n demo -- /bin/sh /scripts/init-script.sh
```
**Now the last step is to deploy the Golang application**

### Deploy the application

```bash
kubectl apply -f ./04-deploy.app.yaml -n demo
```

### Get the ingress of the application

```bash
# demo-webapp is the service/ingress name
kubectl describe ingress demo-accelerate -n demo
```

## Tricks and tips
### How to delete the deployments

```bash
kubectl delete -f ./01-deploy.redis.yaml -n demo
kubectl delete -f ./02-create.configmap.yaml -n demo
kubectl delete -f ./03-create.redis.client.pod.cli.yaml -n demo
kubectl delete -f ./04-deploy.app.yaml -n demo

# Or delete everything:
kubectl delete namespace demo
```

___
[◀️ Previous](./04--docker-bake.md) | [Next: The End ▶️](./06-the-end.md)


