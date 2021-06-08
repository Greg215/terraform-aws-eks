# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket = "terraform-state-devops-training-bucket"
    key    = "instance/terraform.tfstate"
    region = "ap-southeast-1"
  }
  required_version = ">= 0.12.0"
}

provider "aws" {
  region  = "ap-southeast-1"
  version = "~> 2.70"
}
