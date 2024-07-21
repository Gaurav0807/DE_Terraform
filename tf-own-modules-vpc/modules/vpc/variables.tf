variable "vpc_config" {
    description = "To get the CIDR and name of VPC from user"
    type = object({
      cidr_block = string
      name = string
    })
  
}