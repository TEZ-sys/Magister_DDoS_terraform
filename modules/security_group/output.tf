output "security_group_defence" {
  value = aws_security_group.defenders_security_group.name
}

output "security_group_alb_sg" {
  value = aws_security_group.alb_sg.name
}