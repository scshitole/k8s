# k8s Bootstrapping clusters with kubeadm
This repository simplifys some of the k8s cluster configuration it uses kubeadm
This will deploy one k8s master and 2 nodes, you can increase the nodes just by incrementing the count value. It uses t2.medium for all the nodes

```
git clone https://github.com/scshitole/k8s.git

```
#### Once done go into the directory k8s
```
terraform output

```
command will provide the ssh for master and node node

#### SSH to the master node and execute the command below and follow the output steps

```
sudo su
kubeadm init --pod-network-cidr=10.244.0.0/16
```
- Note down the join command which you need to execute on the k8s nodes

- You will see output shown below on the master k8s node

```
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

  You should now deploy a pod network to the cluster.
  Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

```

- Then you can join any number of worker nodes by running the following on each  as root:

```
kubeadm join 10.0.0.100:6443 --token wuipg1.vimk1zvlm2e93o03 \
	--discovery-token-ca-cert-hash sha256:b8b9b05e1e87c21d5d5712ab3a44b2721b9a6eee315ee927e40b5521xxx41
```
- Once you followed above commands on master  you should see below master not ready ..

```
root@ip-10-0-0-100:/home/ubuntu# kubectl get nodes
NAME            STATUS     ROLES                  AGE     VERSION
ip-10-0-0-100   NotReady   control-plane,master   3m50s   v1.21.1
```
- Run join command on nodes

```
ubuntu@ip-10-0-0-168:~$ sudo su
root@ip-10-0-0-168:/home/ubuntu# kubeadm join 10.0.0.100:6443 --token wuipg1.vimk1zvlm2e93o03 --discovery-token-ca-cert-hash sha256:b8b9b05e1e87c21d5d5712ab3a44b2721b9a6eee315ee927e40b55219093341e

root@ip-10-0-0-100:/home/ubuntu# kubectl get nodes
NAME            STATUS     ROLES                  AGE   VERSION
ip-10-0-0-100   NotReady   control-plane,master   11m   v1.21.1
ip-10-0-0-168   NotReady   <none>                 64s   v1.21.1
```
- Next what you do is run the join commands on the node and do the Install Network Addon below on master to make all nodes into *READY STATE*

- Install Network Addon (flannel)

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

root@ip-10-0-0-100:/home/ubuntu# kubectl get nodes
NAME            STATUS   ROLES                  AGE     VERSION
ip-10-0-0-100   Ready    control-plane,master   12m     v1.21.1
ip-10-0-0-168   Ready    <none>                 2m11s   v1.21.1
```
- you can also use below command on master node to generate the join command
```
kubeadm token create --print-join-command
```
- If you want to use kubectl from your labtop then follow steps below

```
terraform output
To_SSH_into_k8s-master_ubuntu = "ssh -i terraform-20210910155113245700000001.pem ubuntu@54.214.222.64"
To_SSH_into_k8s-worker = [
"ssh -i terraform-20210910155113245700000001.pem ubuntu@34.221.61.160",
"ssh -i terraform-20210910155113245700000001.pem ubuntu@54.202.23.84",
]
```
- ssh into the k8s master node using the above command

```
sudo su
kubeadm reset
kubeadm init --apiserver-cert-extra-sans=<Public IP of k8s Master>
```
- ssh into each nodes and execute the commands
```
sudo su
kubeadm reset
kubeadm join 10.0.0.100:6443 --token aaz8gb.sjen8vdgqioveudo \
> --discovery-token-ca-cert-hash sha256:facb4e17018e6e48142ec6bd1fa88810da2667b9ff8f537a3298ccafa90926d2

```

- copy  k8s config from k8s master to you labtop at ~/.kube/config 
```
scp -i terraform-20210910155113245700000001.pem ubuntu@54.214.222.64:/etc/kubernetes/admin.conf ~/.kube/config

```

- Replace the private IP in the ~/.kube/config file by the Public IP of k8s master

```
server: https://10.0.0.100:6443 by  server: https://<publicIPofk8sMaster>:6443
```
