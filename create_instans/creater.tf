terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

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

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2Z5nPIvrkgu/r9W8JcqkTlZqXFyIlA09biF+qGjQ9yO3quw8WzfyWFOJySg6O4BOJY6O0e48XVl/gH/cU4Rdcj+C2tiiYHQmV7NLljsAn5d4SCNhZBnTVh4n84U1mwzeCZRWV69fZ6K9+5cRBsncb9ut5+OrEpm/mc43OGeVD170p1a7GjXyc+UGUDlYRRaWUJPNqWq/LA9ZlOpMlF2meyZ2p0W9m3mx9RrHbATUzpoZ58/vC663GWHYQpek4l/rvm0v+/1qKxCXMXF3jsCAN2XC3h9WlDPsecT+UD1RogVu1Et6A+9LaVx2thPa7LkosIp3fIdAd+HGI/oL5rKWPpIHjvD4abHKOhAwwgkHwU+xAw+e16mHxCTFqTOaMIa+63avb+jN3SCZkBLqCD3uuArwL09TqcKnmH7TWZb3dnrgfXlDlDz863TRgtmc3gawGqZKTGlAAN1hH9tSGvJRwNQnLzvnkrTFdspEFQVGwWLTl8RO+SqhfUOK2J3th1h8= profiles@dell"
}

resource "aws_instance" "terraform" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "${var.public_key}"

  user_data = <<EOF
#
EOF
}