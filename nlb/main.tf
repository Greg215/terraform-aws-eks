# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Network load balancer
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

resource "aws_lb" "nlb" {
  name               = "nlb-${var.name}"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.vpc_public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
}

resource "aws_lb_target_group" "target_groups" {
  count = length(var.listeners.*.target_groups)

  name              = "tg-${var.name}-to-${var.listeners.*.target_groups[count.index].port}"
  port              = var.listeners.*.target_groups[count.index].port
  proxy_protocol_v2 = var.listeners.*.target_groups[count.index].proxy_protocol
  protocol          = "TCP"

  health_check {
    enabled  = true
    protocol = "TCP"
    port     = var.listeners.*.target_groups[count.index].health_check_port
  }
  vpc_id = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "nlb_listeners" {
  count = length(var.listeners)

  load_balancer_arn = aws_lb.nlb.arn
  port              = var.listeners[count.index].port
  protocol          = var.listeners[count.index].protocol
  ssl_policy        = var.listeners[count.index].protocol == "TLS" ? var.ssl_policy : null
  certificate_arn   = var.listeners[count.index].protocol == "TLS" ? var.aws-load-balancer-ssl-cert-arn : null
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_groups[count.index].arn
  }
}

#====================================================
# SG FOR NLB INGRESS CONTROLLER USAGE
#====================================================

# CREATE A NEW SG AND OUTPUT IT TO USE ON EKS MODULE
resource "aws_security_group" "sg_nlb_k8s" {
  count                  = length(var.security_group_for_eks) > 0 ? 1 : 0 # Should be only 1 security group always
  name                   = "${var.name}-nlb-worker-access"
  revoke_rules_on_delete = true
  description            = "Allow traffic from NLB to reach K8S instances"
  vpc_id                 = var.vpc_id
}

resource "aws_security_group_rule" "allow_inbound_from_target_groups" {
  count             = length(var.security_group_for_eks)
  type              = "ingress"
  from_port         = var.security_group_for_eks[count.index].port_from
  to_port           = var.security_group_for_eks[count.index].port_to
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_nlb_k8s[0].id
  description       = "Allow Worker nodes to accept request from LB"
  cidr_blocks       = var.security_group_for_eks[count.index].cidr_block
}
