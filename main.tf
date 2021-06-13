module "test_instance" {
  source = "./ec2"

  aws_region         = var.aws_region
  name_tag           = var.name_tag
  vpc_security_group = module.vpc_sg.security-group-id
  subnet_id = element(module.subnets.public_subnet_ids, 0)
}

module "vpc_sg" {
  source = "./sg"

  vpc_id   = module.vpc.vpc_id
  name_tag = var.sg_name_tag
}

module "vpc" {
  source = "./vpc"
  cidr_block = "172.31.208.0/22"
}

module "subnets" {
  source              = "./subnet"
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
}