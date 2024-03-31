provider "aws" {
    region = "us-east-1"
}

module "creation_instance" {
    source = "./modules/Instance"
}