provider "aws" { 
    access_key = "${var.AWS_ACCESS_KEY}"
    secret_key = "${var.AWS_SECRET_KEY}"
    region = "${var.AWS_REGION}"
}

terraform {
  backend "s3" {
    bucket = "cloudfrog-tf-states"
    key    = "tf_states/terraform.tfstate"
    dynamodb_table = "cloudfrog-tf-states"
    region = "eu-west-2"
  }
}
