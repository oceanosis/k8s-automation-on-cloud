- IAM User for kops
```shell script
aws iam create-group --group-name kops

aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/IAMFullAccess --group-name kops
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess --group-name kops

aws iam create-user --user-name kops

aws iam add-user-to-group --user-name kops --group-name kops

aws iam create-access-key --user-name kops
```

- Create a route53 domain for your cluster
> Create hosted zones
```shell script
aws route53 create-hosted-zone --name kops.icloudfrog.co.uk --caller-reference 2
```

- Create an S3 bucket to store your clusters state

```shell script
aws s3 mb s3://kops.icloudfrog.co.uk --region eu-west-2
export KOPS_STATE_STORE=s3://kops.icloudfrog.co.uk
```

- Build cluster
```shell script
  export NODE_SIZE=${NODE_SIZE:-t3.medium}
  export MASTER_SIZE=${MASTER_SIZE:-t3.large}
  export ZONES=${ZONES:-"eu-west-2a,eu-west-2b,eu-west-2c"}
  export MASTERZONES=${MASTERZONES:-"eu-west-2a"}

  kops create cluster --name=kops.icloudfrog.co.uk \
  --cloud=aws \
  --state=s3://kops.icloudfrog.co.uk \
  --zones $ZONES \
  --node-size $NODE_SIZE \
  --master-size $MASTER_SIZE \
  --master-zones $MASTERZONES \
  --master-count 1 \
  --node-count=1 \
  --dns-zone=icloudfrog.co.uk \
  --networking weave \
  --topology private \
  --bastion="true" \
  --network-cidr=10.0.0.0/16 \
  --ssh-public-key=~/.ssh/automation \
  --admin-access=$TF_VAR_trusted_ip_range \
  --yes \
  --dry-run -oyaml > kops_cluster.yaml

# Create Cluster Config
kops create -f kops_cluster.yaml

# Create a new ssh public key called admin.
kops create secret sshpublickey admin -i ~/.ssh/automation.pub \
  --name kops.icloudfrog.co.uk --state s3://kops.icloudfrog.co.uk

# Create Cluster Resources
kops update cluster kops.icloudfrog.co.uk --yes
```

- Test
```shell script
kops validate cluster --wait 10m
ssh -A -i ~/.ssh/automation ubuntu@bastion.kops.icloudfrog.co.uk

```

- Edit 
```shell script
# Remove a node 
kubectl drain <node-name> --ignore-daemonsets --delete-local-data
kops edit ig nodes
kops update cluster --yes
```


- Destroy all
```shell script
kops delete cluster kops.icloudfrog.co.uk --yes
aws s3 rb s3://kops.icloudfrog.co.uk --region eu-west-2
aws route53 delete-hosted-zone \
  --id $(aws route53 list-hosted-zones-by-name --dns-name kops.icloudfrog.co.uk \
  --output text --query "HostedZones[].Id" | cut -d'/' -f3)
```