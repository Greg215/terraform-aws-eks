# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region in which all resources will be created"
  type        = string
  default     = "ap-southeast-1"
}

variable "zone_id" {
  description = "Hosted Zone ID"
  type        = string
}

variable "type" {
  description = "Record Type"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# Generally, you don't have to input all the variables as below, only for the resources you needed
# ---------------------------------------------------------------------------------------------------------------------

variable "records" {
  description = "Records information that need to be created"
  type = list(object({
    NAME   = string,
    RECORD = string,
    TTL    = number,
  }))
  default = []
}

variable "records_with_weight" {
  description = "Records with Weight"
  type = list(object({
    NAME   = string,
    RECORD = string,
    TTL    = number,
    WEIGHT = number,
    SID    = string,
  }))
  default = []
}

variable "records_with_alias" {
  description = "Records with Alias"
  type = list(object({
    NAME                   = string,
    RECORD                 = string,
    ZONE_ID                = string,
    EVALUATE_TARGET_HEALTH = bool,
  }))
  default = []
}

variable "records_with_alias_weight" {
  description = "Records with Alias and Weight"
  type = list(object({
    NAME    = string,
    RECORD  = string,
    ZONE_ID = string,
    TTL     = number,
    SID     = string,
    COUNTRY = string,
  }))
  default = []
}
