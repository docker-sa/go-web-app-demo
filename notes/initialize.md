## Reset everything

```bash
./init.sh
```

### In Docker Desktop

- Enable background SBOM Indexing
- Turn on the containerd image store
- Chose the default builder

### Kube requirements

```bash
kubectl config get-contexts
k9s --all-namespaces

helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik

# namespace
kubectl create namespace demo --dry-run=client -o yaml | kubectl apply -f -
# if the namespace already exists with apps; you can delete with this command:
# kubectl delete namespace demo

kubectl apply -f ./01-deploy.redis.yaml -n demo
kubectl apply -f ./02-create.configmap.yaml -n demo
kubectl apply -f ./03-create.redis.client.pod.cli.yaml -n demo

# test the deployment of the application
kubectl apply -f ./04-deploy.app.yaml -n demo

# ✋✋✋ you can delete the deployment of the webapp with these commands:
kubectl delete -f ./04-deploy.app.yaml -n demo


```

> We do not need this part anymore:
```bash
# Run the script from the redis-client pod to load the data into Redis
#kubectl exec redis-client -n demo -- /bin/sh /scripts/init-script.sh
```
