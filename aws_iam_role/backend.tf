terraform {
  backend "s3" {
    bucket = "tf-bucket-s3-demo"
    key = "backend_iam.tfstate"
    region = "eu-north-1"
  }
}