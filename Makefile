.PHONY: help
help:            ## Help for command list
	@echo ""
	@echo "Deploy Kubernetes on AWS"
	@echo "Before running export TF_VARS"
	@echo ""
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'


.PHONY: kubespray
kubespray:       ## Deploy a sample K8S Cluster with kubespray
	@echo "Deploy EKS Resources"
	./scripts/eks_pipeline.sh

.PHONY: kubeadm
kubeadm:         ## Deploy a sample K8S Cluster with kubeadm
	@echo "Deploying a sample K8S Cluster with kubeadm"
	./scripts/eks_pipeline.sh

.PHONY: eks
eks:             ## Deploy a sample EKS Cluster
	@echo "Deploying EKS Resources"
	./scripts/eks_pipeline.sh

.PHONY: kops
kops:            ## Deploy a sample K8S Cluster with KOPS
	@echo "Deploying K8S on AWS with KOPS"
	./scripts/kops_pipeline.sh

.PHONY: destroy
destroy:         ## Destroy all resources
	@echo "destroy all resources"
	./scripts/destroy.sh
	

.PHONY: test
test:            ## Test my cluster
	@echo "Testing..."
	./scripts/test.sh