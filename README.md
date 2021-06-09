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

Step 5: Install Network Addon (flannel)

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
