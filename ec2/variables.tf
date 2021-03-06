variable "zone_id" {
  default = "Z07374591FC76OBQXEXUL"
}

variable "subdomain" {
  default = "training.visiontech.com.sg"
}

variable "aws_region" {
  description = "The AWS region in which the resources will be created."
  type        = string
  default     = "ap-southeast-1"
}

variable "name_tag" {
  default = "test"
}

variable "vpc_security_group" {
  default = ""
}

variable "subnet_id" {
  default = ""
}