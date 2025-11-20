output "module_vpc_id" {
  value = var.create_resource["network"] ? aws_vpc.defenders_vpc.id : null
}
output "module_defenders_public_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.defenders_public_subnet.id : null
}
output "module_defenders_private_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.defenders_private_subnet.id : null
}
output "module_defenders_sub_public_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.defenders_sub_public_subnet.id : null
}