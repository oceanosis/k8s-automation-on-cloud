
resource "aws_security_group" "public-sg" {
  vpc_id = aws_vpc.main.id
  name = "public-sg"
  description = "security group that allows ssh,http and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
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
  vpc_id = aws_vpc.main.id
  name = "private-sg"
  description = "security group that allows only internal ingress traffic and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "private-sg"
  }
}


resource "aws_network_acl" "public-NACL" {
  vpc_id       = aws_vpc.main.id
  subnet_ids   = [ data.aws_subnet.public.id ]

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.trusted_ip_range
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.trusted_ip_range
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = var.trusted_ip_range
    from_port  = 32768
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = var.trusted_ip_range
    from_port  = 32768
    to_port    = 65535
  }
  tags = {
    Name = "public-acl"
  }
}




resource "aws_network_acl" "private-NACL" {
  vpc_id       = aws_vpc.main.id
  subnet_ids   = [ data.aws_subnet.private.id ]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "private-acl"
  }
}
