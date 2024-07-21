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

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "aws-s3-bucket-demo-test"
  
}

resource "aws_s3_object" "bucket-data" {
    bucket = aws_s3_bucket.s3_bucket.bucket
    source = "./myfile.txt"
    key="mydata.txt"
  
}