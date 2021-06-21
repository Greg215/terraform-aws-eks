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

variable "name" {
  default = "greg-demo-vision"
}

variable "key_name" {
  default = "devops-training"
}

variable "image_id" {
  default = "ami-0afeae4543435bb1b"
}

variable "instance_type" {
  default = "t2.small"
}

variable "health_check_type" {
  type        = string
  description = "Controls how health checking is done. Valid values are `EC2` or `ELB`"
  default     = "EC2"
}

variable "min_size" {
  type        = number
  description = "The minimum size of the autoscale group"
  default     = 2
}

variable "max_size" {
  type        = number
  description = "The maximum size of the autoscale group"
  default     = 5
}

variable "wait_for_capacity_timeout" {
  type        = string
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior"
  default     = "5m"
}

variable "autoscaling_policies_enabled" {
  type        = bool
  default     = true
  description = "Whether to create `aws_autoscaling_policy` and `aws_cloudwatch_metric_alarm` resources to control Auto Scaling"
}

variable "cpu_utilization_high_threshold_percent" {
  type        = number
  default     = 70
  description = "The value against which the specified statistic is compared"
}

variable "cpu_utilization_low_threshold_percent" {
  type        = number
  default     = 30
  description = "The value against which the specified statistic is compared"
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
  default     = "1.18"
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}

