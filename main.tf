locals {
  # enforce usage of eks_worker_ami_name_filter variable to set the right kubernetes version for EKS workers,
  # otherwise the first version of Kubernetes supported by AWS (v1.11) for EKS workers will be used, but
  # EKS control plane will use the version specified by kubernetes_version variable.
  eks_worker_ami_name_filter = "amazon-eks-node-${var.kubernetes_version}*"
  cluster_name               = module.eks_cluster.eks_cluster_id
  kubernetes_config_map_id   = module.eks_cluster.kubernetes_config_map_id
}

module "vpc" {
  source     = "./vpc"
  name       = var.name
  cidr_block = "172.31.208.0/22" #172.31.212.0/22     172.31.216.0/22
}

module "subnets" {
  source              = "./subnet"
  eks_cluster_name    = var.name
  vpc_id              = module.vpc.vpc_id
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
}

# load balancer
module "network_loadbalancer" {
  source                = "./nlb"
  name                  = var.name
  aws_region            = var.aws_region
  vpc_id                = module.vpc.vpc_id
  vpc_public_subnet_ids = module.subnets.public_subnet_ids

  listeners = [
    {
      port     = 80
      protocol = "TCP",
      target_groups = {
        port              = 30080
        proxy_protocol    = false
        health_check_port = "traffic-port"
      }
    }
  ]

  # below security group will need to be changed, once we know which port and ip.
  security_group_for_eks = [
    {
      port_from  = 0
      port_to    = 65535
      protocol   = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
  ]
  # this value will be needed when the https required.
  #  aws-load-balancer-ssl-cert-arn =
}

module "eks_workers" {
  source        = "./eks-worker"
  name          = module.eks_cluster.eks_cluster_id
  key_name      = var.key_name
  image_id      = var.image_id
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.subnets.public_subnet_ids
  min_size      = var.min_size
  max_size      = var.max_size

  cluster_name                       = module.eks_cluster.eks_cluster_id
  cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
  cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data

  cluster_security_group_id              = var.cluster_security_group_id
  additional_security_group_ids          = [module.network_loadbalancer.security_group_k8s]
  cluster_security_group_ingress_enabled = var.cluster_security_group_ingress_enabled
  associate_public_ip_address            = true

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled = false //set false for the policy

  target_group_arns = concat(module.network_loadbalancer.target_group_arns)
}

module "eks_cluster" {
  source     = "./eks-cluster"
  name       = var.name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.subnets.public_subnet_ids

  kubernetes_version    = var.kubernetes_version
  oidc_provider_enabled = false

  workers_role_arns          = [module.eks_workers.workers_role_arn]
  workers_security_group_ids = [module.eks_workers.security_group_id]
}

module "route53" {
  source  = "./route53-records"
  zone_id = "Z07374591FC76OBQXEXUL"
  type    = "CNAME"
  records = [
    {
      NAME   = "greg215.training.visiontech.com.sg"
      RECORD = module.network_loadbalancer.dns_name
      TTL    = "300"
    },
  ]
}
