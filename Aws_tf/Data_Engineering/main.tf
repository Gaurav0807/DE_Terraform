
variable "region" {
    description = "Aws Region"
  
}

provider "aws" {
    region = var.region
}

resource "aws_s3_bucket" "s3_bucket" {  #Creation of s3 bucket 
    bucket = "testing-bucket-gr"
  
}



# resource "aws_s3_bucket" "bucket" { # Creation of multiple Bucket using iteration
#     for_each = local.s3_bucket_name
#     bucket = each.key
#     versioning {
#       enabled = local.s3_bucket_configs[each.key].versioning
#     }
#     tags = {
#         project_type = local.s3_bucket_configs[each.key].project_type
#     }
# }

resource "aws_s3_object" "airline_data_object" {  #Load data to s3 bucket

    bucket = aws_s3_bucket.s3_bucket.id

    key = "/Airlines_Reviews_and_Rating.csv"
    source = "./Airlines_Reviews_and_Rating.csv"

}

resource "aws_glue_catalog_database" "data_catalog_db" {
  name = "db_name_test"
}


resource "aws_iam_role" "glue_role" {
  name = "glue_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "glue_crawler_policy_access_s3" {
    name = "AWSGlueServiceRoleAccessingS3TripDataBucket"
    path = "/"
    description = "This execution policy for Glue crawler for accessing S3 bucket"

    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource": "*"
      }
  ]
  })
  
}

resource "aws_iam_role_policy_attachment" "attaching_service_role" {
    role = aws_iam_role.glue_role.id 
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
  
}

resource "aws_iam_role_policy_attachment" "attaching_s3_policy" {
    role = aws_iam_role.glue_role.id 
    policy_arn = aws_iam_policy.glue_crawler_policy_access_s3.arn
  
}


resource "aws_glue_crawler" "data_crawler" {
  name          = "data-crawler"
  database_name = aws_glue_catalog_database.data_catalog_db.name
  role          = aws_iam_role.glue_role.name
  table_prefix = "airfline_review_rating"
  s3_target {
      path = "s3://${aws_s3_bucket.s3_bucket.bucket}/"
    }
  }


resource "aws_iam_policy" "bucket_access_s3" {
    name = "LambdaS3AccessPolicy"
    description = "IAm Policy for lambda to access all s3 bucket "

    policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource": "*"
      }
  ]
  })
  
}



# output "value_bucket" {  #Output print statement
#     value = [aws_s3_bucket.s3_bucket.region, aws_s3_bucket.s3_bucket.arn]
  
# }