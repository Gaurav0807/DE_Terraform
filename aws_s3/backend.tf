terraform {
  backend "s3" {
    bucket = "tf-bucket-s3-demo"
    key = "backend.tfstate"
    region = "eu-north-1"
  }
}