output "defenders_private_subnet" {
    value=aws_subnet.defenders_private_subnet.id
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.defenders_vpc.id
}
output "subnets_public" {
  value = aws_subnet.defenders_public_subnet.id
}

output "subnets_public_sub" {
  value = aws_subnet.defenders_sub_public_subnet.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.defenders_NATgw.id
}