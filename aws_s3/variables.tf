variable "region" {
    description = "Aws S3 region bucket"
    type=string
    //default = "eu-north-1"
    validation {
      condition = var.region=="eu-north-1" || var.region == "us-east-1"
      error_message = "only eu-north-1 and us-east-1 is allowed"
    }
}