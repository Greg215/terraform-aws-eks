module "test_instance" {
  source = "./ec2"

  zone_id = var.zone_id
  subdomain = var.subdomain
  aws_region = var.aws_region
}