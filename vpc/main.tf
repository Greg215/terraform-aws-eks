# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# VPC creation
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name       = "vpc-${var.name}"
    managed_by = "terraform"
  }
}

# If `aws_default_security_group` is not defined, it would be created implicitly with access `0.0.0.0/0`
resource "aws_default_security_group" "vpc-sg" {
  count  = var.enable_default_security_group_with_custom_rules ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "default-sg-${var.name}"
  }
}

resource "aws_internet_gateway" "vpc-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name       = "gateway-${var.name}"
    managed_by = "terraform"
  }
}
