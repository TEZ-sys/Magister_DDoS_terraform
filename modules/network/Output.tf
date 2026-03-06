output "module_vpc_id" {
  value = var.create_resource["network"] ? aws_vpc.vpc[0].id : null
}
output "module_public_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.public_subnet[0].id : null
}
output "module_private_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.private_subnet[0].id : null
}
output "module_sub_public_subnet_id" {
  value = var.create_resource["network"] ? aws_subnet.sub_public_subnet[0].id : null
}