provider "aws" { 
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
    region = var.AWS_REGION
    #profile = "k8s_profile"
}

terraform {
    required_version = ">= 0.13.0"
    required_providers {
        aws = {
            version = ">= 3.1.0"
            source = "hashicorp/aws"
        }
    }
#  backend "s3" {
#    bucket = "cloudfrog-tf-states"
#   key    = "tf_states/terraform.tfstate"
#   dynamodb_table = "cloudfrog-tf-states"
#   region = "eu-west-2"
# }
}
