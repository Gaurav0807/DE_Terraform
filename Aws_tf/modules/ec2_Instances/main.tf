provider "aws" {
    alias = "aws_instance"
    region = "us-east-1"
}

variable "ami" {
    description = "This is AMI(Amazon Machine Image) for Instance in us-east-1"
  
}

variable "instance_type" {
    description = "Instance Type for AMI"
  
}

resource "aws_instance" "gaurav_instance" {
    ami = var.ami
    provider = "aws.aws_instance"
    instance_type = var.instance_type

}