output "instance-id" {
  value = module.test_instance.instance-id
}

output "instance-pub-ip" {
  value = module.test_instance.instance-pub-ip
}

output "instance-pub-dns" {
  value = module.test_instance.instance-pub-dns
}

output "instance-pri-ip" {
  value = module.test_instance.instance-pri-ip
}

output "training-dns" {
  value = module.test_instance.training-dns
}

output "pub-subnets" {
  value = module.subnets.public_subnet_ids
}