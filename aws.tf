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

resource "aws_instance" "build" {
  key_name = "${var.public_key}"
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

resource "aws_instance" "prod" {
  key_name = "${var.public_key}"
  ami           = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  user_data = <<EOF
#!/bin/bash
apt update && apt install default-jdk tomcat9 awscli -y
export AWS_ACCESS_KEY_ID="${var.AWS_ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${var.AWS_SECRET_ACCESS_KEY}"
export AWS_DEFAULT_REGION=eu-central-1
aws s3 cp s3://mybacket1.dmitry-test.com/hello-1.0.war /var/lib/tomcat9/webapps/
EOF
}