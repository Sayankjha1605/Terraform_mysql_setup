output "mysql" {
  value = aws_instance.mysql.public_ip
  description = "this variable for ec2 insatance public ip store"
}

output "user_data" {
  value = aws_instance.mysql.user_data
}
