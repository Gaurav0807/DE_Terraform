terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ec2_instance_creation" {
  ami = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"

  tags = {
    Name = "Aws_ec2_instance"
  }
}

output "aws_ec2_instance" {
  value = "AMI : ${aws_instance.ec2_instance_creation.ami}, Subnet Id : ${aws_instance.ec2_instance_creation.subnet_id}, Tags :  ${aws_instance.ec2_instance_creation.tags["Name"]}"
}