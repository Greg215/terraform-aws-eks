# terraform-aws-eks-workers 

Terraform module to provision AWS resources to run EC2 worker nodes for [Elastic Container Service for Kubernetes](https://aws.amazon.com/eks/).

Instantiate it multiple times to create many EKS worker node pools with specific settings such as GPUs, EC2 instance types, or autoscale parameters.

---

## Introduction

The module provisions the following resources:

- IAM Role and Instance Profile to allow Kubernetes nodes to access other AWS services
- Security Group with rules for EKS workers to allow networking traffic
- AutoScaling Group with Launch Template to configure and launch worker instances
- AutoScaling Policies and CloudWatch Metric Alarms to monitor CPU utilization on the EC2 instances and scale the number of instance in the AutoScaling Group up or down.
If you don't want to use the provided functionality, or want to provide your own policies, disable it by setting the variable `autoscaling_policies_enabled` to `"false"`.

## Usage

For a complete example, see [examples/complete](examples/complete)

```hcl
  provider "aws" {
    region = var.region
  }

  locals {
    # The usage of the specific kubernetes.io/cluster/* resource tags below are required
    # for EKS and Kubernetes to discover and manage networking resources
    # https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html#base-vpc-networking
    tags = merge(var.tags, map("kubernetes.io/cluster/${var.cluster_name}", "shared"))
  }

  module "vpc" {
    source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.0"
    namespace  = var.namespace
    stage      = var.stage
    name       = var.name
    cidr_block = "172.16.0.0/16"
    tags       = local.tags
  }

  module "subnets" {
    source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.0"
    availability_zones   = var.availability_zones
    namespace            = var.namespace
    stage                = var.stage
    name                 = var.name
    vpc_id               = module.vpc.vpc_id
    igw_id               = module.vpc.igw_id
    cidr_block           = module.vpc.vpc_cidr_block
    nat_gateway_enabled  = false
    nat_instance_enabled = false
    tags                 = local.tags
  }

  module "eks_workers" {
    source                             = "git::https://github.com/cloudposse/terraform-aws-eks-workers.git?ref=master"
    namespace                          = var.namespace
    stage                              = var.stage
    name                               = var.name
    instance_type                      = var.instance_type
    vpc_id                             = module.vpc.vpc_id
    subnet_ids                         = module.subnets.public_subnet_ids
    health_check_type                  = var.health_check_type
    min_size                           = var.min_size
    max_size                           = var.max_size
    wait_for_capacity_timeout          = var.wait_for_capacity_timeout
    cluster_name                       = var.cluster_name
    cluster_endpoint                   = var.cluster_endpoint
    cluster_certificate_authority_data = var.cluster_certificate_authority_data
    cluster_security_group_id          = var.cluster_security_group_id

    # Auto-scaling policies and CloudWatch metric alarms
    autoscaling_policies_enabled           = var.autoscaling_policies_enabled
    cpu_utilization_high_threshold_percent = var.cpu_utilization_high_threshold_percent
    cpu_utilization_low_threshold_percent  = var.cpu_utilization_low_threshold_percent
  }
```






## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional_security_group_ids | Additional list of security groups that will be attached to the autoscaling group | list(string) | `<list>` | no |
| after_cluster_joining_userdata | Additional commands to execute on each worker node after joining the EKS cluster (after executing the `bootstrap.sh` script). For mot info, see https://kubedex.com/90-days-of-aws-eks-in-production | string | `` | no |
| allowed_cidr_blocks | List of CIDR blocks to be allowed to connect to the worker nodes | list(string) | `<list>` | no |
| allowed_security_groups | List of Security Group IDs to be allowed to connect to the worker nodes | list(string) | `<list>` | no |
| associate_public_ip_address | Associate a public IP address with an instance in a VPC | bool | `false` | no |
| attributes | Additional attributes (e.g. `1`) | list(string) | `<list>` | no |
| autoscaling_group_tags | Additional tags only for the autoscaling group, e.g. "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "ci-cd:NoSchedule". | map(string) | `<map>` | no |
| autoscaling_policies_enabled | Whether to create `aws_autoscaling_policy` and `aws_cloudwatch_metric_alarm` resources to control Auto Scaling | bool | `true` | no |
| aws_iam_instance_profile_name | The name of the existing instance profile that will be used in autoscaling group for EKS workers. If empty will create a new instance profile. | string | `` | no |
| before_cluster_joining_userdata | Additional commands to execute on each worker node before joining the EKS cluster (before executing the `bootstrap.sh` script). For mot info, see https://kubedex.com/90-days-of-aws-eks-in-production | string | `` | no |
| block_device_mappings | Specify volumes to attach to the instance besides the volumes specified by the AMI | object | `<list>` | no |
| bootstrap_extra_args | Extra arguments to the `bootstrap.sh` script to enable `--enable-docker-bridge` or `--use-max-pods` | string | `` | no |
| cluster_certificate_authority_data | The base64 encoded certificate data required to communicate with the cluster | string | - | yes |
| cluster_endpoint | EKS cluster endpoint | string | - | yes |
| cluster_name | The name of the EKS cluster | string | - | yes |
| cluster_security_group_id | Security Group ID of the EKS cluster | string | - | yes |
| cluster_security_group_ingress_enabled | Whether to enable the EKS cluster Security Group as ingress to workers Security Group | bool | `true` | no |
| cpu_utilization_high_evaluation_periods | The number of periods over which data is compared to the specified threshold | number | `2` | no |
| cpu_utilization_high_period_seconds | The period in seconds over which the specified statistic is applied | number | `300` | no |
| cpu_utilization_high_statistic | The statistic to apply to the alarm's associated metric. Either of the following is supported: `SampleCount`, `Average`, `Sum`, `Minimum`, `Maximum` | string | `Average` | no |
| cpu_utilization_high_threshold_percent | The value against which the specified statistic is compared | number | `90` | no |
| cpu_utilization_low_evaluation_periods | The number of periods over which data is compared to the specified threshold | number | `2` | no |
| cpu_utilization_low_period_seconds | The period in seconds over which the specified statistic is applied | number | `300` | no |
| cpu_utilization_low_statistic | The statistic to apply to the alarm's associated metric. Either of the following is supported: `SampleCount`, `Average`, `Sum`, `Minimum`, `Maximum` | string | `Average` | no |
| cpu_utilization_low_threshold_percent | The value against which the specified statistic is compared | number | `10` | no |
| credit_specification | Customize the credit specification of the instances | object | `null` | no |
| default_cooldown | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start | number | `300` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| disable_api_termination | If `true`, enables EC2 Instance Termination Protection | bool | `false` | no |
| ebs_optimized | If true, the launched EC2 instance will be EBS-optimized | bool | `false` | no |
| eks_worker_ami_name_filter | AMI name filter to lookup the most recent EKS AMI if `image_id` is not provided | string | `amazon-eks-node-*` | no |
| eks_worker_ami_name_regex | A regex string to apply to the AMI list returned by AWS | string | `^amazon-eks-node-[1-9,\.]+-v\d{8}$` | no |
| elastic_gpu_specifications | Specifications of Elastic GPU to attach to the instances | object | `null` | no |
| enable_monitoring | Enable/disable detailed monitoring | bool | `true` | no |
| enabled | Whether to create the resources. Set to `false` to prevent the module from creating any resources | bool | `true` | no |
| enabled_metrics | A list of metrics to collect. The allowed values are `GroupMinSize`, `GroupMaxSize`, `GroupDesiredCapacity`, `GroupInServiceInstances`, `GroupPendingInstances`, `GroupStandbyInstances`, `GroupTerminatingInstances`, `GroupTotalInstances` | list(string) | `<list>` | no |
| force_delete | Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling | bool | `false` | no |
| health_check_grace_period | Time (in seconds) after instance comes into service before checking health | number | `300` | no |
| health_check_type | Controls how health checking is done. Valid values are `EC2` or `ELB` | string | `EC2` | no |
| image_id | EC2 image ID to launch. If not provided, the module will lookup the most recent EKS AMI. See https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html for more details on EKS-optimized images | string | `` | no |
| instance_initiated_shutdown_behavior | Shutdown behavior for the instances. Can be `stop` or `terminate` | string | `terminate` | no |
| instance_market_options | The market (purchasing) option for the instances | object | `null` | no |
| instance_type | Instance type to launch | string | - | yes |
| key_name | SSH key name that should be used for the instance | string | `` | no |
| kubelet_extra_args | Extra arguments to pass to kubelet, like "--register-with-taints=dedicated=ci-cd:NoSchedule --node-labels=purpose=ci-worker" | string | `` | no |
| load_balancers | A list of elastic load balancer names to add to the autoscaling group. Only valid for classic load balancers. For ALBs, use `target_group_arns` instead | list(string) | `<list>` | no |
| max_size | The maximum size of the autoscale group | number | - | yes |
| metrics_granularity | The granularity to associate with the metrics to collect. The only valid value is 1Minute | string | `1Minute` | no |
| min_elb_capacity | Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes | number | `0` | no |
| min_size | The minimum size of the autoscale group | number | - | yes |
| mixed_instances_policy | policy to used mixed group of on demand/spot of differing types. Launch template is automatically generated. https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#mixed_instances_policy-1 | object | `null` | no |
| name | Solution name, e.g. 'app' or 'cluster' | string | `app` | no |
| namespace | Namespace, which could be your organization name, e.g. 'eg' or 'cp' | string | `` | no |
| placement | The placement specifications of the instances | object | `null` | no |
| placement_group | The name of the placement group into which you'll launch your instances, if any | string | `` | no |
| protect_from_scale_in | Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events | bool | `false` | no |
| scale_down_adjustment_type | Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity` | string | `ChangeInCapacity` | no |
| scale_down_cooldown_seconds | The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start | number | `300` | no |
| scale_down_policy_type | The scalling policy type, either `SimpleScaling`, `StepScaling` or `TargetTrackingScaling` | string | `SimpleScaling` | no |
| scale_down_scaling_adjustment | The number of instances by which to scale. `scale_down_scaling_adjustment` determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity | number | `-1` | no |
| scale_up_adjustment_type | Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are `ChangeInCapacity`, `ExactCapacity` and `PercentChangeInCapacity` | string | `ChangeInCapacity` | no |
| scale_up_cooldown_seconds | The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start | number | `300` | no |
| scale_up_policy_type | The scalling policy type, either `SimpleScaling`, `StepScaling` or `TargetTrackingScaling` | string | `SimpleScaling` | no |
| scale_up_scaling_adjustment | The number of instances by which to scale. `scale_up_adjustment_type` determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity | number | `1` | no |
| service_linked_role_arn | The ARN of the service-linked role that the ASG will use to call other AWS services | string | `` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', or 'test' | string | `` | no |
| subnet_ids | A list of subnet IDs to launch resources in | list(string) | - | yes |
| suspended_processes | A list of processes to suspend for the AutoScaling Group. The allowed values are `Launch`, `Terminate`, `HealthCheck`, `ReplaceUnhealthy`, `AZRebalance`, `AlarmNotification`, `ScheduledActions`, `AddToLoadBalancer`. Note that if you suspend either the `Launch` or `Terminate` process types, it can prevent your autoscaling group from functioning properly. | list(string) | `<list>` | no |
| tags | Additional tags (e.g. `{ BusinessUnit = "XYZ" }` | map(string) | `<map>` | no |
| target_group_arns | A list of aws_alb_target_group ARNs, for use with Application Load Balancing | list(string) | `<list>` | no |
| termination_policies | A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are `OldestInstance`, `NewestInstance`, `OldestLaunchConfiguration`, `ClosestToNextInstanceHour`, `Default` | list(string) | `<list>` | no |
| use_custom_image_id | If set to `true`, will use variable `image_id` for the EKS workers inside autoscaling group | bool | `false` | no |
| use_existing_aws_iam_instance_profile | If set to `true`, will use variable `aws_iam_instance_profile_name` to run EKS workers using an existing AWS instance profile that was created outside of this module, workaround for error like `count cannot be computed` | bool | `false` | no |
| use_existing_security_group | If set to `true`, will use variable `workers_security_group_id` to run EKS workers using an existing security group that was created outside of this module, workaround for errors like `count cannot be computed` | bool | `false` | no |
| vpc_id | VPC ID for the EKS cluster | string | - | yes |
| wait_for_capacity_timeout | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. Setting this to '0' causes Terraform to skip all Capacity Waiting behavior | string | `10m` | no |
| wait_for_elb_capacity | Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over `min_elb_capacity` behavior | number | `0` | no |
| workers_role_policy_arns | List of policy ARNs that will be attached to the workers default role on creation | list(string) | `<list>` | no |
| workers_role_policy_arns_count | Count of policy ARNs that will be attached to the workers default role on creation. Needed to prevent Terraform error `count can't be computed` | number | `0` | no |
| workers_security_group_id | The name of the existing security group that will be used in autoscaling group for EKS workers. If empty, a new security group will be created | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling_group_arn | ARN of the AutoScaling Group |
| autoscaling_group_default_cooldown | Time between a scaling activity and the succeeding scaling activity |
| autoscaling_group_desired_capacity | The number of Amazon EC2 instances that should be running in the group |
| autoscaling_group_health_check_grace_period | Time after instance comes into service before checking health |
| autoscaling_group_health_check_type | `EC2` or `ELB`. Controls how health checking is done |
| autoscaling_group_id | The AutoScaling Group ID |
| autoscaling_group_max_size | The maximum size of the AutoScaling Group |
| autoscaling_group_min_size | The minimum size of the AutoScaling Group |
| autoscaling_group_name | The AutoScaling Group name |
| launch_template_arn | ARN of the launch template |
| launch_template_id | The ID of the launch template |
| security_group_arn | ARN of the worker nodes Security Group |
| security_group_id | ID of the worker nodes Security Group |
| security_group_name | Name of the worker nodes Security Group |
| workers_role_arn | ARN of the worker nodes IAM role |
| workers_role_name | Name of the worker nodes IAM role |
