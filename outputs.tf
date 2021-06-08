#-------------------------------------------------------------------------------------------------
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# outputs
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
output "instance-id" {
  value = aws_instance.devops-training.*.id
}

output "instance-pub-ip" {
  value = aws_instance.devops-training.*.public_ip
}

output "instance-pub-dns" {
  value = aws_instance.devops-training.*.public_dns
}

output "instance-pri-ip" {
  value = aws_instance.devops-training.*.private_ip
}

output "training-dns" {
  value = aws_route53_record.training_dns.*.name
}