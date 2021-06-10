module "test_instance" {
  source = "./ec2"

  zone_id            = var.zone_id
  subdomain          = var.subdomain
  aws_region         = var.aws_region
  name_tag           = var.name_tag
  vpc_security_group = module.vpc_sg.security-group-id
}

module "vpc_sg" {
  source = "./sg"

  vpc_id   = var.vpc_id
  name_tag = var.sg_name_tag
}