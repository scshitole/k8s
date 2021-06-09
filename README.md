# k8s Bootstrapping clusters with kubeadm
This repository simplifys some of the k8s cluster configuration it uses kubeadm

```
git clone https://github.com/scshitole/k8s.git

```
- Once done go into the directory k8s, terraform output command will provide the ssh for master and node node
- SSH to the master node and execute the command below and follow the output steps

```
kubeadm init --pod-network-cidr=10.244.0.0/16
```
- Note down the join command which you need to execute on the k8s nodes

You will see output shown below on the master k8s node

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

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.0.100:6443 --token wuipg1.vimk1zvlm2e93o03 \
	--discovery-token-ca-cert-hash sha256:b8b9b05e1e87c21d5d5712ab3a44b2721b9a6eee315ee927e40b5521xxx41
```
Once you followed above commands on master  you should see below master not ready ..

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
