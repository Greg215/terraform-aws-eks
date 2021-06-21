# terraform-aws-eks-cluster

Terraform module to provision an [EKS](https://aws.amazon.com/eks/) cluster on AWS.


---

## Introduction

The module provisions the following resources:

- EKS cluster of master nodes that can be used together with the [terraform-aws-eks-workers](https://github.com/cloudposse/terraform-aws-eks-workers),
  [terraform-aws-eks-node-group](https://github.com/cloudposse/terraform-aws-eks-node-group) and
  [terraform-aws-eks-fargate-profile](https://github.com/cloudposse/terraform-aws-eks-fargate-profile)
  modules to create a full-blown cluster
- IAM Role to allow the cluster to access other AWS services
- Security Group which is used by EKS workers to connect to the cluster and kubelets and pods to receive communication from the cluster control plane
- The module creates and automatically applies an authentication ConfigMap to allow the wrokers nodes to join the cluster and to add additional users/roles/accounts


__NOTE:__ In `auth.tf`, added `ignore_changes = [data["mapRoles"]]` to the `kubernetes_config_map` for the following reason:
- Provision the EKS cluster and then the Kubernetes Auth ConfigMap to map additional roles/users/accounts to Kubernetes groups
- Then wait for the cluster to become available and for the ConfigMap to get provisioned (see `data "null_data_source" "wait_for_cluster_and_kubernetes_configmap"` in `examples/complete/main.tf`)
- Then provision a managed Node Group
- Then EKS updates the Auth ConfigMap and adds worker roles to it (for the worker nodes to join the cluster)
- Since the ConfigMap is modified outside of Terraform state, Terraform wants to update it (remove the roles that EKS added) on each `plan/apply`

If you want to modify the Node Group (e.g. add more Node Groups to the cluster) or need to map other IAM roles to Kubernetes groups,
set the variable `kubernetes_config_map_ignore_role_changes` to `false` and re-provision the module. Then set `kubernetes_config_map_ignore_role_changes` back to `true`.

## Usage

```hcl

  locals {
    # The usage of the specific kubernetes.io/cluster/* resource tags below are required
    # for EKS and Kubernetes to discover and manage networking resources
    # https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html#base-vpc-networking

    eks_worker_ami_name_filter = "amazon-eks-node-${var.kubernetes_version}*"
  }

  module "vpc" {
    source     = "./vpc"
    cidr_block = "172.16.0.0/16"
  }

  module "subnets" {
    source               = "./subnet"
    vpc_id               = module.vpc.vpc_id
    igw_id               = module.vpc.igw_id
    cidr_block           = module.vpc.vpc_cidr_block
    nat_gateway_enabled  = false
    nat_instance_enabled = false
  }

  module "eks_worker" {
    source                             = "./eks-worker"
    instance_type                      = var.instance_type
    eks_worker_ami_name_filter          = local.eks_worker_ami_name_filter
    vpc_id                             = module.vpc.vpc_id
    subnet_ids                         = module.subnets.public_subnet_ids
    health_check_type                  = var.health_check_type
    min_size                           = var.min_size
    max_size                           = var.max_size
    wait_for_capacity_timeout          = var.wait_for_capacity_timeout
    cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
    cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data
    cluster_security_group_id          = module.eks_cluster.security_group_id

    # Auto-scaling policies and CloudWatch metric alarms
    autoscaling_policies_enabled           = var.autoscaling_policies_enabled
    cpu_utilization_high_threshold_percent = var.cpu_utilization_high_threshold_percent
    cpu_utilization_low_threshold_percent  = var.cpu_utilization_low_threshold_percent
  }

  module "eks_cluster" {
    source     = "./eks-cluster"
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.subnets.public_subnet_ids

    kubernetes_version    = var.kubernetes_version
    oidc_provider_enabled = false

    workers_security_group_ids   = [module.eks_workers.security_group_id]
    workers_role_arns            = [module.eks_workers.workers_role_arn]
  }
```

Module usage with two worker groups:

```hcl
  module "eks_workers" {
    source                             = "./eks-worker"
    name                               = "eks-worker-1"
    instance_type                      = "t3.small"
    vpc_id                             = module.vpc.vpc_id
    subnet_ids                         = module.subnets.public_subnet_ids
    health_check_type                  = var.health_check_type
    min_size                           = var.min_size
    max_size                           = var.max_size
    wait_for_capacity_timeout          = var.wait_for_capacity_timeout
    cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
    cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data
    cluster_security_group_id          = module.eks_cluster.security_group_id

    # Auto-scaling policies and CloudWatch metric alarms
    autoscaling_policies_enabled           = var.autoscaling_policies_enabled
    cpu_utilization_high_threshold_percent = var.cpu_utilization_high_threshold_percent
    cpu_utilization_low_threshold_percent  = var.cpu_utilization_low_threshold_percent
  }

  module "eks_workers_2" {
    source                             = "./eks-worker"
    name                               = "eks-worker-2"
    instance_type                      = "t3.medium"
    vpc_id                             = module.vpc.vpc_id
    subnet_ids                         = module.subnets.public_subnet_ids
    health_check_type                  = var.health_check_type
    min_size                           = var.min_size
    max_size                           = var.max_size
    wait_for_capacity_timeout          = var.wait_for_capacity_timeout
    cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
    cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data
    cluster_security_group_id          = module.eks_cluster.security_group_id

    # Auto-scaling policies and CloudWatch metric alarms
    autoscaling_policies_enabled           = var.autoscaling_policies_enabled
    cpu_utilization_high_threshold_percent = var.cpu_utilization_high_threshold_percent
    cpu_utilization_low_threshold_percent  = var.cpu_utilization_low_threshold_percent
  }

  module "eks_cluster" {
    source     = "./eks-cluster"
    name       = var.name
    vpc_id     = module.vpc.vpc_id
    subnet_ids = module.subnets.public_subnet_ids

    kubernetes_version    = var.kubernetes_version
    oidc_provider_enabled = false

    workers_role_arns          = [module.eks_workers.workers_role_arn, module.eks_workers_2.workers_role_arn]
    workers_security_group_ids = [module.eks_workers.security_group_id, module.eks_workers_2.security_group_id]
  }
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| allowed_cidr_blocks | List of CIDR blocks to be allowed to connect to the EKS cluster | list(string) | `<list>` | no |
| allowed_security_groups | List of Security Group IDs to be allowed to connect to the EKS cluster | list(string) | `<list>` | no |
| apply_config_map_aws_auth | Whether to apply the ConfigMap to allow worker nodes to join the EKS cluster and allow additional users, accounts and roles to acces the cluster | bool | `true` | no |
| cluster_log_retention_period | Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. | number | `0` | no |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| enabled_cluster_log_types | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`] | list(string) | `<list>` | no |
| endpoint_private_access | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false | bool | `false` | no |
| endpoint_public_access | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true | bool | `true` | no |
| kubernetes_config_map_ignore_role_changes | Set to `true` to ignore IAM role changes in the Kubernetes Auth ConfigMap | bool | `true` | no |
| kubernetes_version | Desired Kubernetes master version. If you do not specify a value, the latest available version is used | string | `1.15` | no |
| local_exec_interpreter | shell to use for local_exec | list(string) | `<list>` | no |
| map_additional_aws_accounts | Additional AWS account numbers to add to `config-map-aws-auth` ConfigMap | list(string) | `<list>` | no |
| map_additional_iam_roles | Additional IAM roles to add to `config-map-aws-auth` ConfigMap | object | `<list>` | no |
| map_additional_iam_users | Additional IAM users to add to `config-map-aws-auth` ConfigMap | object | `<list>` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `` | no |
| oidc_provider_enabled | Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html | bool | `false` | no |
| public_access_cidrs | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. | list(string) | `<list>` | no |
| region | AWS Region | string | - | yes |
| subnet_ids | A list of subnet IDs to launch the cluster in | list(string) | - | yes |
| vpc_id | VPC ID for the EKS cluster | string | - | yes |
| wait_for_cluster_command | `local-exec` command to execute to determine if the EKS cluster is healthy. Cluster endpoint are available as environment variable `ENDPOINT` | string | `curl --silent --fail --retry 60 --retry-delay 5 --retry-connrefused --insecure --output /dev/null $ENDPOINT/healthz` | no |
| workers_role_arns | List of Role ARNs of the worker nodes | list(string) | `<list>` | no |
| workers_security_group_ids | Security Group IDs of the worker nodes | list(string) | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| eks_cluster_arn | The Amazon Resource Name (ARN) of the cluster |
| eks_cluster_certificate_authority_data | The Kubernetes cluster certificate authority data |
| eks_cluster_endpoint | The endpoint for the Kubernetes API server |
| eks_cluster_id | The name of the cluster |
| eks_cluster_identity_oidc_issuer | The OIDC Identity issuer for the cluster |
| eks_cluster_identity_oidc_issuer_arn | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account |
| eks_cluster_managed_security_group_id | Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads |
| eks_cluster_role_arn | ARN of the EKS cluster IAM role |
| eks_cluster_version | The Kubernetes server version of the cluster |
| kubernetes_config_map_id | ID of `aws-auth` Kubernetes ConfigMap |
| security_group_arn | ARN of the EKS cluster Security Group |
| security_group_id | ID of the EKS cluster Security Group |
| security_group_name | Name of the EKS cluster Security Group |
