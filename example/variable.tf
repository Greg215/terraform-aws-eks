variable "aws_region" {
  description = "The AWS region in which the resources will be created."
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "The cidr block of the VPC that will be created."
  type        = string
  default     = "172.31.208.0/22"
}

variable "route53_zone_id" {
  description = "The route53 zone id."
  type        = string
  default     = "Z07374591FC76OBQXEXUL"
}

variable "domian" {
  description = "The route53 zone id."
  type        = string
  default     = "training.visiontech.com.sg"
}

variable "name" {
  default = "greg-eks-demo"
}

variable "key_name" {
  default = "devops-training"
}

variable "image_id" {
  default = "ami-0afeae4543435bb1b"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
  default     = 3
}

variable "max_size" {
  type        = number
  description = "The maximum size of the autoscale group"
  default     = 5
}

variable "autoscaling_policies_enabled" {
  type        = bool
  default     = true
  description = "Whether to create `aws_autoscaling_policy` and `aws_cloudwatch_metric_alarm` resources to control Auto Scaling"
}

variable "cluster_security_group_id" {
  type        = string
  description = "Security Group ID of the EKS cluster"
  default     = ""
}

variable "cluster_security_group_ingress_enabled" {
  type        = bool
  description = "Whether to enable the EKS cluster Security Group as ingress to workers Security Group"
  default     = false
}

variable "kubernetes_version" {
  type        = string
  default     = "1.19"
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}

variable "aws-load-balancer-ssl-cert-arn" {
  description = "The ACM arn"
  type        = string
  default     = ""
}
