#---------------------------------standart-VPC----------------------------------
resource "aws_vpc" "vpc" {
  count            = var.create_resource["network"] ? 1 : 0
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#---------------------------------standart-IGW----------------------------------
resource "aws_internet_gateway" "IGW" {
  count  = var.create_resource["network"] ? 1 : 0
  vpc_id = aws_vpc.vpc[count.index].id
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#---------------------------------Public Subnet---------------------------------
resource "aws_subnet" "public_subnet" {
  count                   = var.create_resource["network"] ? 1 : 0
  vpc_id                  = aws_vpc.vpc[count.index].id
  cidr_block              = var.public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones["az1"]
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#---------------------------------Private Subnet---------------------------------
resource "aws_subnet" "private_subnet" {
  count             = var.create_resource["network"] ? 1 : 0
  vpc_id            = aws_vpc.vpc[count.index].id
  cidr_block        = var.private_subnet
  availability_zone = var.availability_zones["az1"]
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#------------------------------------Public Route Table--------------------------
resource "aws_route_table" "PublicRT" {
  count  = var.create_resource["network"] ? 1 : 0
  vpc_id = aws_vpc.vpc[count.index].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW[count.index].id
  }
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#------------------------------------Private Route Table-------------------------
resource "aws_route_table" "PrivateRT" {
  count  = var.create_resource["network"] ? 1 : 0
  vpc_id = aws_vpc.vpc[count.index].id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATgw[count.index].id
  }
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "PublicRTassociation" {
  count          = var.create_resource["network"] ? 1 : 0
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.PublicRT[count.index].id
}

#---------------------------------Private Route Table Association----------------
resource "aws_route_table_association" "PrivateRTassociation" {
  count          = var.create_resource["network"] ? 1 : 0
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.PrivateRT[count.index].id
}

#---------------------------------sub_Public Subnet---------------------------------
resource "aws_subnet" "sub_public_subnet" {
  count                   = var.create_resource["network"] ? 1 : 0
  vpc_id                  = aws_vpc.vpc[count.index].id
  cidr_block              = var.sub_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones["az2"]
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#------------------------------------sub_Public Route Table--------------------------
resource "aws_route_table" "sub_PublicRT" {
  count  = var.create_resource["network"] ? 1 : 0
  vpc_id = aws_vpc.vpc[count.index].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW[count.index].id
  }
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "sub_PublicRTassociation" {
  count          = var.create_resource["network"] ? 1 : 0
  subnet_id      = aws_subnet.sub_public_subnet[count.index].id
  route_table_id = aws_route_table.sub_PublicRT[count.index].id
}

#-------------------------------------Elastic IP---------------------------------
resource "aws_eip" "nat_eip" {
  count = var.create_resource["network"] ? 1 : 0
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}

#--------------------------------NAT Gateway-------------------------------------
resource "aws_nat_gateway" "NATgw" {
  count         = var.create_resource["network"] ? 1 : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags = {
    Name        = var.resource_owner["name"]
    Owner       = var.resource_owner["owner"]
    Environment = var.environment
  }
}