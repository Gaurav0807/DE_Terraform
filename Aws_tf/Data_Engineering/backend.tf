terraform {
  backend "s3" {
    bucket = "gr-nike-adfh"
    key = "terraform_state_file/de_terraform.tfstate"
    region = "us-east-1"
  }
}