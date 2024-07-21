terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "s3_bucket_creation" {
  bucket = "aws-tf-bucket-test"
}

//Data Copy 
resource "aws_s3_object" "data" { 
  bucket = aws_s3_bucket.s3_bucket_creation.bucket
  source = "./file.txt"
  key = "mydata_copy.txt"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket_creation.bucket
}
