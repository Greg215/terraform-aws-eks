# Route 53 Public Hosted Zones

## Description
This module use for creating route 53 public record specific (like A, CNAME, AAAA, txt, MX etc.). Its not able to create NS record, for that please refer to (https://github.com/sumup/infrastructure-modules/tree/master/networking/route53-public). It also does not contain the resources for creating SOA and Geolocation.  
This Terraform Modules manages public DNS entries using [Amazon Route 53](https://aws.amazon.com/route53/).


## How do you use this module?

See the [root README](/README.md) for instructions on using modules.

## Core concepts

To understand core concepts like what is route 53, what is a public hosted zone, and more, see the [route 53
documentation](https://aws.amazon.com/documentation/route53/).

# Usage:

```
inputs = {
  zone_id = XXXXXXXXXXX
  type = "CNAME"

  records = [
     {
       "NAME"   = "cname1.example1.com"
       "RECORD" = "example1.com"
       "TTL"    = "300"
     },
     {
       "NAME"   = "cname2.example2.com"
       "RECORD" = "example2.com"
       "TTL"    = "300"
     },
   ]

  records_with_weight = [
     {
       "NAME"   = "weighted-cname.example.com"
       "RECORD" = "10.0.0.10"
       "TTL"    = "300"
       "WEIGHT" = "100"
       "SID"    = "cname-with-weight-100"
     },
     {
       "NAME"   = "weighted-cname.example.com"
       "RECORD" = "10.0.0.20"
       "TTL"    = "300"
       "WEIGHT" = "200"
       "SID"    = "cname-with-weight-200"
     },
   ]
  }
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| region | If specified, the AWS region this bucket should reside in. Otherwise, the region used by the callee | string | `ap-southeast-1` | no |
| zone_id | ID of the hosted zone to contain this record  (or specify `zone_name`) | string | `` | yes |
| type | The records type you want to create. | string | - | yes |
| NAME | DNS name of target resource (e.g. ALB, ELB) | string | - | yes |
| ZONE_ID | ID of target resource (e.g. ALB, ELB) | string | - | yes |
| EVALUATE_TARGET_HEALTH | Set to true if you want Route 53 to determine whether to respond to DNS queries | bool | `false` | no |
| RECORD | The source target | string | - | yes |
| TTL | (Required for non-alias records) The TTL of the record. | string | - | no |


## Outputs

| Name | Description |
|------|-------------|
| hostnames | List of DNS records |