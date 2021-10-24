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
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2Z5nPIvrkgu/r9W8JcqkTlZqXFyIlA09biF+qGjQ9yO3quw8WzfyWFOJySg6O4BOJY6O0e48XVl/gH/cU4Rdcj+C2tiiYHQmV7NLljsAn5d4SCNhZBnTVh4n84U1mwzeCZRWV69fZ6K9+5cRBsncb9ut5+OrEpm/mc43OGeVD170p1a7GjXyc+UGUDlYRRaWUJPNqWq/LA9ZlOpMlF2meyZ2p0W9m3mx9RrHbATUzpoZ58/vC663GWHYQpek4l/rvm0v+/1qKxCXMXF3jsCAN2XC3h9WlDPsecT+UD1RogVu1Et6A+9LaVx2thPa7LkosIp3fIdAd+HGI/oL5rKWPpIHjvD4abHKOhAwwgkHwU+xAw+e16mHxCTFqTOaMIa+63avb+jN3SCZkBLqCD3uuArwL09TqcKnmH7TWZb3dnrgfXlDlDz863TRgtmc3gawGqZKTGlAAN1hH9tSGvJRwNQnLzvnkrTFdspEFQVGwWLTl8RO+SqhfUOK2J3th1h8= profiles@dell"
}

resource "aws_instance" "terraform" {
  key_name = "${aws_key_pair.deployer.key_name}"
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  user_data = <<EOF
#!/bin/bash
apt update && apt install default-jdk maven awscli -y
git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git
mvn package -f /boxfuse-sample-java-war-hello/pom.xml
export AWS_ACCESS_KEY_ID="${var.AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${var.AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION=eu-central-1
aws s3 cp /boxfuse-sample-java-war-hello/target/hello-1.0.war s3://mybacket1.dmitry-test.com
EOF
}