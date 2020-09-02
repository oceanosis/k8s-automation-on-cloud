
> Create keypair
```shell script
aws ec2 import-key-pair --key-name=mykeypair --public-key-material fileb://~/.ssh/automation.pub
```
* To encrypt the Kubernetes secrets with a customer master key (CMK) from AWS Key Management Service (AWS KMS), first create a CMK using the create-key operation.
Add the --encryption-config parameter to the aws eks create-cluster command. Encryption of Kubernetes secrets can only be enabled when the cluster is created.
```shell script
MY_KEY_ARN=$(aws kms create-key --query KeyMetadata.Arn —-output text)
--encryption-config '[{"resources":["secrets"],"provider":{"keyArn":"$MY_KEY_ARN"}}]'
```
> Create Cluster in existing VPC
```shell script
eksctl create cluster \
--name=cloudfrog \
--instance-prefix=cf \
--region=eu-west-2 \
--node-private-networking \
--vpc-nat-mode=Single \
--version=1.17 \
--ssh-public-key=mykeypair \
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

> Deploy AWS VPC CNI 
```shell script
helm repo add eks https://aws.github.io/eks-charts
helm install --name aws-vpc-cni --namespace kube-system eks/aws-vpc-cni

```

Test Cluster 
```shell script
export KUBECONFIG=$KUBECONFIG:~/.kube/eksctl/clusters/cloudfrog
kubectl get nodes
kubectl create deploy nginx --image=nginx
kubectl expose deploy nginx --port 80 --type=LoadBalancer
curl -k $(kubectl get svc nginx -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```

> Delete all
```shell script
aws ec2 delete-key-pair --key-name=mykeypair
eksctl delete cluster --region=eu-west-2 --name=cloudfrog
```

