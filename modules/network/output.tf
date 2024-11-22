output "module_vpc_id" {
  value = aws_vpc.defenders_vpc.id
}
output "module_defenders_public_subnet_id" {
  value = aws_subnet.defenders_public_subnet.id
}
output "module_defenders_private_subnet_id" {
  value = aws_subnet.defenders_private_subnet.id
}
output "module_defenders_sub_public_subnet_id" {
  value=aws_subnet.defenders_sub_public_subnet.id
}