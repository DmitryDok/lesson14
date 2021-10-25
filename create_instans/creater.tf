terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

resource "aws_key_pair" "deployer1" {
  key_name   = "deployer-key1"
  public_key = "${var.public_key}"
}

resource "aws_instance" "my-machine" {
  count = 5
  ami = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "my-machine-${count.index}"
         }
  key_name = "${aws_key_pair.deployer1.key_name}"

  user_data = <<EOF
#
EOF
}