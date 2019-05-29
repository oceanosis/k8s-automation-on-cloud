resource "aws_security_group" "public-sg" {
  vpc_id = "${aws_vpc.main.id}"
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
      cidr_blocks = ["0.0.0.0/0"]
  } 
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 
tags = {
    Name = "public-sg"
  }
}

#resource "aws_security_group" "private-sg" {
#  vpc_id = "${aws_vpc.main.id}"
#  name = "private-sg"
#  description = "security group that allows only internal ingress traffic and all egress traffic"
#  egress {
#      from_port = 0
#      to_port = 0
#      protocol = "-1"
#      cidr_blocks = ["10.0.0.0/16"]
#  }
#  ingress {
#      from_port = 3306
#      to_port = 3306
#      protocol = "tcp"
#      security_groups = ["${aws_security_group.public-sg.id}"]              # allowing access from our example instance
#  }
#  tags = {
#    Name = "private-sg"
#  }
#}
#

resource "aws_network_acl" "public-NACL" {
  vpc_id       = "${aws_vpc.main.id}"
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  tags = {
    Name = "public-acl"
  }
}


#data "aws_subnet_ids" "private" {
#  vpc_id = "${aws_vpc.main.id}"
#  tags = {
#    Tier = "Private"
#  }
#}

#resource "aws_network_acl" "private-NACL" {
#  vpc_id = "${aws_vpc.main.id}"
#  subnet_ids     = ["${data.aws_subnet_ids.private.ids}"]
#
#  ingress {
#    protocol   = -1
#    rule_no    = 100
#    action     = "allow"
#    cidr_block = "10.0.0.0/16"
#    from_port  = 0
#    to_port    = 0
#  }
#
#  egress {
#    protocol   = -1
#    rule_no    = 100
#    action     = "allow"
#    cidr_block = "10.0.0.0/16"
#    from_port  = 0
#    to_port    = 0
#  }
#  tags = {
#    Name = "private-acl"
#  }
#}
