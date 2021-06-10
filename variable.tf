variable "aws_region" {
  description = "The AWS region in which the resources will be created."
  type        = string
  default     = "ap-southeast-1"
}

variable "name_tag" {
  default = "test"
}

variable "vpc_id" {
  default = "vpc-fdcf029b"
}

variable "sg_name_tag" {
  default = "allow-all"
}