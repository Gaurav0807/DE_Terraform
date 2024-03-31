terraform {
  backend "s3" {
    bucket = "gr-nike-adfh"
    key = "terraform_state_file/terraform.tfstate"
    region = "us-east-1"
  }
}