resource "aws_route53_record" "training_dns" {
  count      = 1
  zone_id    = var.zone_id
  name       = "devops-${count.index + 1}.${var.subdomain}"
  type       = "A"
  ttl        = "300"
  records    = [element(aws_instance.devops-training.*.public_ip, count.index)]
  depends_on = [aws_instance.devops-training]
}