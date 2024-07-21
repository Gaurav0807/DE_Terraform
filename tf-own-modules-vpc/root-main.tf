provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_config = {
    cidr_block = "10.0.0.0/16"
    name = "my-test-vpc"
    
  }
}