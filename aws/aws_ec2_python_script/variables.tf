variable "aws_region" {
  description = "Aws Region"
  type = string
  
  validation {
    condition = var.aws_region=="us-east-1"
    error_message = "Only US East N Virgenia accept"
  }
}