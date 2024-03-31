output "public_ip" {  #This will print output for public_ip address for aws_example for example 2
    description = "Public IP Address for EC2 Instances"  
    value = [aws_instance.example2.public_ip, aws_instance.example2.subnet_id, aws_instance.example2.private_ip]
}

