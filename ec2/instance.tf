data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "devops-training" {
  count                       = 1
  ami                         = "ami-04013074f44779e67"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  key_name                    = "devops-training"
  monitoring                  = false
  vpc_security_group_ids      = [var.vpc_security_group]
  subnet_id                   = "subnet-2577d16d"

  tags = {
    Name = var.name_tag
  }
}