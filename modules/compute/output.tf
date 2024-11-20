output "defender_instance_ip" {
  value = aws_instance.defender_instance.public_ip
}

output "defender_instance_id" {
  value = aws_instance.defender_instance.id
}