
resource "aws_security_group" "public-sg" {
  vpc_id = module.vpc.vpc_id
  name = "public-sg"
  description = "security group that allows ssh"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 32768
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.trusted_ip_range]
  }
tags = {
    Name = "public-sg"
  }
}

resource "aws_security_group" "private-sg" {
  vpc_id = module.vpc.vpc_id
  name = "private-sg"
  description = "security group that allows only internal ingress traffic "
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ aws_security_group.public-sg.id ]
  }
  ingress {
    from_port = 32768
    to_port =  65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "private-sg"
  }
}


resource "aws_network_acl" "public-NACL" {
  vpc_id = module.vpc.vpc_id
  subnet_ids   = data.aws_subnet_ids.public.ids

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.trusted_ip_range
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 110
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name = "public-acl"
  }
  depends_on = [ data.aws_subnet_ids.public ]
}

resource "aws_network_acl" "private-NACL" {
  vpc_id = module.vpc.vpc_id
  subnet_ids   = data.aws_subnet_ids.private.ids

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "private-acl"
  }
  depends_on = [ data.aws_subnet_ids.private ]

}
