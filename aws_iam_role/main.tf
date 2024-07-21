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

locals {
  users_data = yamldecode(file("./users.yaml")).users

  user_role_pair = flatten([for user in local.users_data: [for role in user.roles: {
    username = user.username
    role = role
  }]])
}

output "users_data_read" {
  value = local.user_role_pair
}

resource "aws_iam_user" "users" {
  for_each = toset(local.users_data[*].username)
  name = each.value
}

#Password Creation
resource "aws_iam_user_login_profile" "login_profile" {
  for_each = aws_iam_user.users
  user = each.value.name
  password_length = 12

  lifecycle {
    ignore_changes = [ 
      password_length,
      password_reset_required,
      pgp_key
     ]
  }

}

#Get password
# output "iam_user_password" {
#   value = [for profile in aws_iam_user_login_profile.login_profile :{
#     id = profile.id
#     password = profile.password
#   }]
# }


resource "aws_iam_user_policy_attachment" "main" {
  for_each = {
    for pair in local.user_role_pair :
    "${pair.username}-${pair.role}" => pair
  }

  user       = aws_iam_user.users[each.value.username].name
  policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}