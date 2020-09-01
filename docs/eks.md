
> Grab private subnet ids of VPC
```shell script
 aws ec2 describe-subnets --filters Name=tag:Name,Values="main-private*" --output text
```
> Create Cluster in existing VPC
```shell script
eksctl create cluster \
--name=cloudfrog \
--instance-prefix=cf \
--region=eu-west-2 \
--vpc-private-subnets=subnet-06aba08309dfae7b9,subnet-0d0fee469ba038249,subnet-055416dafc40bee19 \
--node-private-networking \
--vpc-nat-mode=Single \
--version=1.17 \
--ssh-public-key=mykeypair \
--node-security-groups=private-sg \
--nodes 2 \
--full-ecr-access \
--external-dns-access \
--alb-ingress-access  \
--auto-kubeconfig
```

> Describe stack
```shell script
eksctl utils describe-stacks \
--region=eu-west-2 --cluster=cloudfrog
```
> CloudWatch enable
```shell script
eksctl utils update-cluster-logging \
--region=eu-west-2 --cluster=cloudfrog
```

helm repo add eks https://aws.github.io/eks-charts
helm install --name aws-vpc-cni --namespace kube-system eks/aws-vpc-cni
