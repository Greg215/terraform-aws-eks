resource "aws_instance" "devops-training" {
  count                       = 1
  ami                         = "ami-04013074f44779e67"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = "devops-training"
  monitoring                  = false
  vpc_security_group_ids      = [var.vpc_security_group]
  subnet_id                   = var.subnet_id

  tags = {
    Name = var.name_tag
  }
}