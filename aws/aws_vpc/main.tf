terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.57.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-backup-tf"
    key = "vpc_state/backend_vpc.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

#VPC
resource "aws_vpc" "aws_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.aws_vpc.id
  tags = {
    Name = "aws_private_subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.aws_vpc.id
  tags = {
    Name = "aws_public_subnet"
  }
}


resource "aws_internet_gateway" "vpc_ignw" {
  vpc_id = aws_vpc.aws_vpc.id
  tags = {
    Name = "ignw_aws_vpc"
  }
}


resource "aws_route_table" "vpc_route_table" {
  vpc_id = aws_vpc.aws_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_ignw.id
    }
}


resource "aws_route_table_association" "public_sub" {
  route_table_id = aws_route_table.vpc_route_table.id
  subnet_id = aws_subnet.public_subnet.id
}