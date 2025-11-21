output "module_vpc_id" {
  value = aws_vpc.standarts_vpc.id
}
output "module_standarts_public_subnet_id" {
  value = aws_subnet.standarts_public_subnet.id
}
output "module_standarts_private_subnet_id" {
  value = aws_subnet.standarts_private_subnet.id
}
output "module_standarts_sub_public_subnet_id" {
  value = aws_subnet.standarts_sub_public_subnet.id
}