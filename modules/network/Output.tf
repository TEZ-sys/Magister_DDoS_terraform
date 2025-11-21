output "module_vpc_id" {
  value = var.create_resource["network"] ? aws_vpc.standart_vpc[0].id : null
}
output "module_standart_public_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.standart_public_subnet[0].id : null
}
output "module_standart_private_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.standart_private_subnet[0].id : null
}
output "module_standart_sub_public_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.standart_sub_public_subnet[0].id : null
}