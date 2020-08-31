variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {
  default = "eu-west-2"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "automation"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "automation.pub"
}

variable "az" {
  default = "eu-west-2a"
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["eu-west-2a","eu-west-2b","eu-west-2c"]
}

variable "trusted_ip_range" {
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "bastion_private_ip" {
  default = ["10.0.1.10"]
}

variable "master_private_ip" {
  default = ["10.0.101.11","10.0.102.11","10.0.103.11"]
}

variable "worker_private_ip" {
  default = ["10.0.101.21","10.0.102.21","10.0.103.21"]
}