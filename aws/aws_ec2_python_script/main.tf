terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.59.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-backup-tf"
    key = "terraform_ec2_airflow/terraform_ec2_state.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Attach Policy
resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::terraform-state-backup-tf",
          "arn:aws:s3:::terraform-state-backup-tf/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}





resource "aws_s3_object" "python_script" {
  bucket = "terraform-state-backup-tf"
  key    = "python/word_count.py"
  source = "./word_count.py"
}

#Data block aws related information
data "aws_vpc" "default" {
    default = true
}

resource "aws_security_group" "allow_web_traffic" {
    name        = "allow_web_traffic"
    description = "Allow web traffic on port 8080"
    vpc_id      = data.aws_vpc.default.id

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_web_traffic"
    }
}


resource "aws_instance" "ec2_instance_creation" {
  ami = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  #security_groups = [aws_security_group.allow_web_traffic.name]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt install -y python3-pip
    sudo snap install aws-cli --classic
    aws s3 cp s3://terraform-state-backup-tf/python/word_count.py /home/ubuntu/word_count.py
    echo "Input file content \nwith aws ec2 instances \nrunning in ubuntu machine" > /home/ubuntu/input.txt
    sudo sh -c 'python3 /home/ubuntu/word_count.py > /home/ubuntu/output.txt'
    aws s3 cp /home/ubuntu/output.txt s3://terraform-state-backup-tf/python/output/output.txt
  EOF
    
    tags = {
        Name = "Aws_ec2_instance"
    }
}

output "aws_ec2_instance" {
  value = "AMI : ${aws_instance.ec2_instance_creation.ami}, Subnet Id : ${aws_instance.ec2_instance_creation.subnet_id}, Tags :  ${aws_instance.ec2_instance_creation.tags["Name"]}"
}




