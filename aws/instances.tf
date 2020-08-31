locals {
  private_subnet_ids = tolist(
    [ module.vpc.private_1_subnet_id, module.vpc.private_2_subnet_id,module.vpc.private_3_subnet_id ]
  )
  public_subnet_ids = tolist(
    [ module.vpc.public_1_subnet_id, module.vpc.public_2_subnet_id,module.vpc.public_3_subnet_id ]
  )
}

data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "mykeypair" {
  key_name = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

module "master" {
  source  = "oceanosis/instance/aws"
  ami_id = data.aws_ami.latest-ubuntu.id
  version = "1.2.4"
  instance_name = "master"
  script_location = "./scripts/prepare_master.sh"
  security_group_ids = aws_security_group.private-sg.id
  subnet_ids = local.private_subnet_ids
  instance_count = 1
  private_ips = var.master_private_ip
  key_name = aws_key_pair.mykeypair.key_name
  tag = {
    app = "kubemaster",
    tier = "Dev"
  }
}

module "worker" {
  source  = "oceanosis/instance/aws"
  ami_id = data.aws_ami.latest-ubuntu.id
  version = "1.2.4"
  instance_name = "worker"
  script_location = "./scripts/prepare_worker.sh"
  security_group_ids = aws_security_group.private-sg.id
  subnet_ids = local.private_subnet_ids
  private_ips = var.worker_private_ip
  instance_count = 2
  key_name = aws_key_pair.mykeypair.key_name
  tag = {
    app = "kubeworker",
    tier = "Dev"
  }
}

module "bastion" {
  source  = "oceanosis/instance/aws"
  ami_id = data.aws_ami.latest-ubuntu.id
  version = "1.2.4"
  instance_name = "bastion"
  script_location = "./scripts/prepare_bastion.sh"
  security_group_ids = aws_security_group.public-sg.id
  private_ips = var.bastion_private_ip
  subnet_ids = local.public_subnet_ids
  instance_count = 1
  key_name = aws_key_pair.mykeypair.key_name
  tag = {
    app = "bastion",
    tier = "Dev"
  }
}