terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  project = "project1"

}
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16" #Range of VPC
  tags = {
    Name = "${local.project}-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.my-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  count = 2
  tags = {
    Name = "${local.project}-subnet-${count.index}"
  }
}

#Multiple Aws Subnet
# resource "aws_subnet" "main2" {
#   vpc_id = aws_vpc.my-vpc.id
#   cidr_block = "10.0.0.0/24"
# }

