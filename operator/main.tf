terraform {}

#Number List
variable "num_list" {
    type = list(number)
    default = [ 0,1,2,4 ]
}

output "output_num_list" {
    value = var.num_list
}

#Object List

variable "person_list" {
    type = list(object({
      fname = string
      lname = string 
    }))
    default = [ {
      fname = "Gaurav"
      lname = "Rawat"
    },
    {
        fname = "shiv"
        lname = "hjjk"
    }
     ]
}

output "person_list_object" {
  value = var.person_list
}



#Map 

variable "map_list" {
    type = map(number)
    default = {
      "one" = 1
      "two" = 2
    }
}

output "map_list_output" {
  value = var.map_list
}

#Local 
locals {
  double = [for num in  var.num_list: num*2]
}

output "output"{
    value = local.double
}

