output "defender_instance_ip" {
  value = aws_instance.defender_instance.public_ip
}

#output "sub_defender_instance_ip" {
#  value = aws_instance.sub_defender_instance.public_ip
#}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}