## Creating a sample kubernetes environment with istio service mesh on AWS 
 

Microservices have become a popular architectural style for building cloud-native applications that are self-contained, independently deployable, resilient and quickly evolve. Additionally, Istio makes it easy to create a network of deployed services with load balancing, service-to-service authentication, monitoring.

---

Therefore, you may use this sample code as a starting point for your development environment. 



## TODO 
> There will be 5 approaches to install kubernetes;
- EKSCTL
- KOPS
- Kubeadm 
- Kubespray
- Kubernetes - the hard way 

> Second part will be deploying istio and creating a sample service mash.

---
```shell script
$ ./create.sh config
$ ssh master-1 -F ./config
```

 
- Test
```shell script
$ terraform validate
$ terraform fmt -check -diff 
$ chronic test.sh
```