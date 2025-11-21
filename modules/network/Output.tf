output "module_vpc_id" {
  value = aws_vpc.standart_vpc.id
}
output "module_standart_public_subnet_id" {
  value = aws_subnet.standart_public_subnet.id
}
output "module_standart_private_subnet_id" {
  value = aws_subnet.standart_private_subnet.id
}
output "module_standart_sub_public_subnet_id" {
  value = aws_subnet.standart_sub_public_subnet.id
}