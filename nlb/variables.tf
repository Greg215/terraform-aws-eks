# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------
variable "vpc_id" {
  description = "The ID of the VPC this NLB will use."
  type        = string
}

variable "vpc_public_subnet_ids" {
  description = "The Public subnet IDs where NLB will be created"
  type        = list(string)
}

variable "aws-load-balancer-ssl-cert-arn" {
  description = "The arn of the TLS certificatec on ACM"
  type        = string
  default     = ""
}

variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS."
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

variable "name" {
  description = "The Network LoadBalancer name"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Configure if NLB will have deletion protection enabled"
  type        = bool
  default     = false
}

variable "listeners" {
  description = "A list of Listener to be attached on NLB"
  type = list(object({
    port     = number
    protocol = string
    target_groups = object({
      port              = number
      proxy_protocol    = bool
      health_check_port = string
    })
  }))

  default = [{
    port     = 443
    protocol = "TCP"
    target_groups = {
      port              = 443
      proxy_protocol    = false
      health_check_port = 443
    }
  }]
}

variable "security_group_for_eks" {
  description = "SG Inbound rules to be created. When using a NLB, you have to control carefully what are the ports open on your instances to avoid having 0.0.0.0/0"
  type = list(object({
    port_from  = number
    port_to    = number
    cidr_block = list(string)
  }))
  default = []

}
