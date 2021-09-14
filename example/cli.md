Generating Pod Manifests via CLI
1. Create a Pod from Nginx Image

Syntax:  kubectl run [NAME-OF-POD] --image=[IMAGE=NAME]

Command:

```
kubectl run nginx --image=nginx

```

2. Create a Pod and Expose a Port

```

kubectl run nginx-port --image=nginx --port=80

```

3. Output the Manifest File

```
kubectl run nginx --image=nginx --port=80 --dry-run=client -o yaml

```

4. Delete PODS

```
kubectl delete pod nginx

kubectl delete pod --all
```

