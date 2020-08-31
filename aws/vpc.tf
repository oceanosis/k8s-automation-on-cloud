

module "vpc" {
  source  = "oceanosis/vpc/aws"
  version = "0.8.0"
}


data "aws_subnet_ids" "public" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "tag:Tier"
    values = ["Public" ]
  }
  depends_on = [ module.vpc]

}
data "aws_subnet_ids" "private" {
  vpc_id = module.vpc.vpc_id
  filter {
    name   = "tag:Tier"
    values = ["Private" ]
  }
  depends_on = [ module.vpc]

}

