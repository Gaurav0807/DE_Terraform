terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = var.region
}

#myserver issa block ka naam haii 
resource "aws_instance" "myserver" {
    ami = "ami-07c8c1b18ca66bb07"
    instance_type = "t3.micro"

    tags = {
        Name = "SampleServer"
    } 
}

