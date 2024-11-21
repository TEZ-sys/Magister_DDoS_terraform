output "module_vpc_id" {
  value = aws_vpc.defenders_vpc
}
output "module_defenders_public_subnet" {
  value = aws_subnet.defenders_public_subnet
}
output "module_defenders_private_subnet" {
  value = aws_subnet.defenders_private_subnet
}
output "module_defenders_sub_public_subnet" {
  value=aws_subnet.defenders_sub_public_subnet
}