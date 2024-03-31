locals {

    s3_bucket_name = toset(["testing-check-bucket","tyesting-ninja-bucket"])

    s3_bucket_configs = {

        testing-check-bucket = {
            versioning = true
            project_type = "demo1"
        }

        tyesting-ninja-bucket = {
            versioning = true
            project_type = "demo2"
        }


    }

}