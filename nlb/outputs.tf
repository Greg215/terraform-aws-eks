output "dns_name" {
  value = aws_lb.nlb.dns_name
}

output "listeners_arns" {
  value = aws_lb_listener.nlb_listeners.*.arn
}

output "target_group_arns" {
  value = aws_lb_target_group.target_groups.*.arn
}

output "security_group_k8s" {
  value = element(concat(aws_security_group.sg_nlb_k8s.*.id, [""]), 0)
}

output "zone_id" {
  value = aws_lb.nlb.zone_id
}
