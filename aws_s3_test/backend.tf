terraform {
  backend "s3" {
    bucket = "tf-bucket-s3-demo"
    key = "backend_terraform_file.tfstate"
    region = "eu-north-1"
   
  }
}