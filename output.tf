#-------------------------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# outputs VPC
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
output "vpc_igw_id" {
  value       = module.vpc.igw_id
  description = "The ID of the Internet Gateway"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "The CIDR block of the VPC"
}

output "vpc_main_route_table_id" {
  value       = module.vpc.vpc_main_route_table_id
  description = "The ID of the main route table associated with this VPC"
}

output "vpc_default_network_acl_id" {
  value       = module.vpc.vpc_default_network_acl_id
  description = "The ID of the network ACL created by default on VPC creation"
}

output "vpc_default_security_group_id" {
  value       = module.vpc.vpc_default_security_group_id
  description = "The ID of the security group created by default on VPC creation"
}

output "vpc_default_route_table_id" {
  value       = module.vpc.vpc_default_route_table_id
  description = "The ID of the route table created by default on VPC creation"
}

output "vpc_ipv6_association_id" {
  value       = module.vpc.vpc_ipv6_association_id
  description = "The association ID for the IPv6 CIDR block"
}

output "vpc_ipv6_cidr_block" {
  value       = module.vpc.ipv6_cidr_block
  description = "The IPv6 CIDR block"
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# outputs subnet
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
output "public_subnet_ids" {
  value       = module.subnets.public_subnet_ids
  description = "IDs of the created public subnets"
}

output "private_subnet_ids" {
  value       = module.subnets.private_subnet_ids
  description = "IDs of the created private subnets"
}

output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "CIDR blocks of the created public subnets"
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "CIDR blocks of the created private subnets"
}

output "public_route_table_ids" {
  value       = module.subnets.public_route_table_ids
  description = "IDs of the created public route tables"
}

output "private_route_table_ids" {
  value       = module.subnets.private_route_table_ids
  description = "IDs of the created private route tables"
}

output "nat_gateway_ids" {
  value       = module.subnets.nat_gateway_ids
  description = "IDs of the NAT Gateways created"
}

output "nat_instance_ids" {
  value       = module.subnets.nat_instance_ids
  description = "IDs of the NAT Instances created"
}

output "availability_zones" {
  value       = module.subnets.availability_zones
  description = "List of Availability Zones where subnets were created"
}

output "availability_zones_number" {
  value       = module.subnets.number_of_AZs
  description = "The number of Availability Zones where subnets were created"
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# outputs eks-worker
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
output "eks-worker-launch_template_id" {
  description = "The ID of the launch template"
  value       = module.eks_workers.launch_template_id
}

output "eks-worker-launch_template_arn" {
  description = "ARN of the launch template"
  value       = module.eks_workers.launch_template_arn
}

output "eks-worker-autoscaling_group_id" {
  description = "The AutoScaling Group ID"
  value       = module.eks_workers.autoscaling_group_id
}

output "eks-worker-autoscaling_group_name" {
  description = "The AutoScaling Group name"
  value       = module.eks_workers.autoscaling_group_name
}

output "eks-worker-autoscaling_group_arn" {
  description = "ARN of the AutoScaling Group"
  value       = module.eks_workers.autoscaling_group_arn
}

output "eks-worker-autoscaling_group_min_size" {
  description = "The minimum size of the AutoScaling Group"
  value       = module.eks_workers.autoscaling_group_min_size
}

output "eks-worker-autoscaling_group_max_size" {
  description = "The maximum size of the AutoScaling Group"
  value       = module.eks_workers.autoscaling_group_max_size
}

output "eks-worker-autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       = module.eks_workers.autoscaling_group_desired_capacity
}

output "eks-worker-autoscaling_group_default_cooldown" {
  description = "Time between a scaling activity and the succeeding scaling activity"
  value       = module.eks_workers.autoscaling_group_default_cooldown
}

output "eks-worker-autoscaling_group_health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  value       = module.eks_workers.autoscaling_group_health_check_grace_period
}

output "eks-worker-autoscaling_group_health_check_type" {
  description = "`EC2` or `ELB`. Controls how health checking is done"
  value       = module.eks_workers.autoscaling_group_health_check_type
}

output "eks-worker-security_group_id" {
  description = "ID of the worker nodes Security Group"
  value       = module.eks_workers.security_group_id
}

output "eks-worker-security_group_arn" {
  description = "ARN of the worker nodes Security Group"
  value       = module.eks_workers.security_group_arn
}

output "eks-worker-security_group_name" {
  description = "Name of the worker nodes Security Group"
  value       = module.eks_workers.security_group_name
}

output "eks-workers_role_arn" {
  description = "ARN of the worker nodes IAM role"
  value       = module.eks_workers.workers_role_arn
}

output "eks-workers_role_name" {
  description = "Name of the worker nodes IAM role"
  value       = module.eks_workers.workers_role_name
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# outputs eks-cluster
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
output "eks_cluster_security_group_id" {
  description = "ID of the EKS cluster Security Group"
  value       = module.eks_cluster.security_group_id
}

output "eks_cluster_security_group_arn" {
  description = "ARN of the EKS cluster Security Group"
  value       = module.eks_cluster.security_group_arn
}

output "eks_cluster_security_group_name" {
  description = "Name of the EKS cluster Security Group"
  value       = module.eks_cluster.security_group_name
}

output "eks_cluster_id" {
  description = "The name of the cluster"
  value       = module.eks_cluster.eks_cluster_id
}

output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = module.eks_cluster.eks_cluster_arn
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the Kubernetes API server"
  value       = module.eks_cluster.eks_cluster_endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes server version of the cluster"
  value       = module.eks_cluster.eks_cluster_version
}

output "eks_cluster_identity_oidc_issuer" {
  description = "The OIDC Identity issuer for the cluster"
  value       = module.eks_cluster.eks_cluster_identity_oidc_issuer
}

output "eks_cluster_identity_oidc_issuer_arn" {
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
  value       = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn
}

output "eks_cluster_certificate_authority_data" {
  description = "The Kubernetes cluster certificate authority data"
  value       = module.eks_cluster.eks_cluster_certificate_authority_data
}

output "eks_cluster_managed_security_group_id" {
  description = "Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads"
  value       = module.eks_cluster.eks_cluster_managed_security_group_id
}

output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = module.eks_cluster.eks_cluster_role_arn
}

output "eks_cluster-config_map_id" {
  description = "ID of `aws-auth` Kubernetes ConfigMap"
  value       = module.eks_cluster.kubernetes_config_map_id
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# outputs NLB
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
output "nlb_dns_name" {
  value = join("://", ["http", module.network_loadbalancer.dns_name])
}

output "nlb-listeners_arns" {
  value = module.network_loadbalancer.listeners_arns
}

output "nlb-target_group_arns" {
  value = module.network_loadbalancer.target_group_arns
}

output "nlb-security_group_k8s" {
  value = module.network_loadbalancer.security_group_k8s
}