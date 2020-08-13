
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

resource "aws_instance" "k8s_master" {
  count = length(var.master_instances)
  ami                  = data.aws_ami.latest-ubuntu.id
  instance_type        = var.master_instance_type
  key_name             = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids = [ aws_security_group.private-sg.id ]
  subnet_id = data.aws_subnet.private.id
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
  ebs_block_device {
    device_name = "/dev/sdh"
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 20
  }
  tags = {
    Name = format("master%d", var.master_instances[ count.index])
  }
}

resource "aws_instance" "k8s_worker" {
  count = length(var.worker_instances)
  ami                  = data.aws_ami.latest-ubuntu.id
  instance_type        = var.worker_instance_type
  key_name             = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids = [ aws_security_group.private-sg.id ]
  subnet_id = data.aws_subnet.private.id
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
  ebs_block_device {
    device_name = "/dev/sdh"
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 20
  }
  tags = {
    Name = format("node%d", var.worker_instances[ count.index])
  }
}

resource "aws_instance" "bastion" {
  ami                  = data.aws_ami.latest-ubuntu.id
  instance_type        = var.master_instance_type
  key_name             = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids = [ aws_security_group.public-sg.id ]
  subnet_id = data.aws_subnet.public.id
  root_block_device {
    volume_type = "gp2"
    volume_size = 10
  }
  tags = {
    Name = "bastion"
  }
}