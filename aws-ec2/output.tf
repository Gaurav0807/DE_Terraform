output "aws_instance_ip_address" {
    value = aws_instance.myserver.public_ip
}
