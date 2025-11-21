#---------------------------------standart-VPC----------------------------------
resource "aws_vpc" "standart_vpc" {
  count            = var.create_resource["network"] ? 1 : 0
  cidr_block       = var.standart_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name        = "${var.resource_owner["name"]}-VPC"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

#---------------------------------standart-IGW----------------------------------
resource "aws_internet_gateway" "standart_IGW" {
  count  = var.create_resource["network"] ? 1 : 0
  vpc_id = aws_vpc.standart_vpc[count.index].id
  tags = {
    Name        = "${var.resource_owner["name"]}-IGW"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

#---------------------------------Public Subnet---------------------------------
resource "aws_subnet" "standart_public_subnet" {
  count                   = var.create_resource["network"] ? 1 : 0
  vpc_id                  = aws_vpc.standart_vpc[count.index].id
  cidr_block              = var.standart_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones["az1"]
  tags = {
    Name        = "${var.resource_owner["name"]}-Pub-Subnet"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

#---------------------------------Private Subnet---------------------------------
resource "aws_subnet" "standart_private_subnet" {
  count             = var.create_resource["network"] ? 1 : 0
  vpc_id            = aws_vpc.standart_vpc[count.index].id
  cidr_block        = var.standart_private_subnet
  availability_zone = var.availability_zones["az1"]
  tags = {
    Name        = "${var.resource_owner["name"]}-Priv-Subnet"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

#------------------------------------Public Route Table--------------------------
resource "aws_route_table" "standart_PublicRT" {
  count  = var.create_resource["network"] ? 1 : 0
  vpc_id = aws_vpc.standart_vpc[count.index].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.standart_IGW[count.index].id
  }
  tags = {
    Name        = "${var.resource_owner["name"]}-PubRT"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

#------------------------------------Private Route Table-------------------------
resource "aws_route_table" "standart_PrivateRT" {
  count  = var.create_resource["network"] ? 1 : 0
  vpc_id = aws_vpc.standart_vpc[count.index].id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.standart_NATgw[count.index].id
  }
  tags = {
    Name        = "${var.resource_owner["name"]}-PrvRT"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "standart_PublicRTassociation" {
  count          = var.create_resource["network"] ? 1 : 0
  subnet_id      = aws_subnet.standart_public_subnet[count.index].id
  route_table_id = aws_route_table.standart_PublicRT[count.index].id
}

#---------------------------------Private Route Table Association----------------
resource "aws_route_table_association" "standart_PrivateRTassociation" {
  count          = var.create_resource["network"] ? 1 : 0
  subnet_id      = aws_subnet.standart_private_subnet[count.index].id
  route_table_id = aws_route_table.standart_PrivateRT[count.index].id
}

#---------------------------------sub_Public Subnet---------------------------------
resource "aws_subnet" "standart_sub_public_subnet" {
  count                   = var.create_resource["network"] ? 1 : 0
  vpc_id                  = aws_vpc.standart_vpc[count.index].id
  cidr_block              = var.standart_sub_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones["az2"]
  tags = {
    Name        = "${var.resource_owner["name"]}-Sub-Pub-Subnet"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

#------------------------------------sub_Public Route Table--------------------------
resource "aws_route_table" "sub_standart_PublicRT" {
  count  = var.create_resource["network"] ? 1 : 0
  vpc_id = aws_vpc.standart_vpc[count.index].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.standart_IGW[count.index].id
  }
  tags = {
    Name        = "${var.resource_owner["name"]}-Sub-PubRT"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Prod_Environment"]
  }
}

#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "sub_standart_PublicRTassociation" {
  count          = var.create_resource["network"] ? 1 : 0
  subnet_id      = aws_subnet.standart_sub_public_subnet[count.index].id
  route_table_id = aws_route_table.sub_standart_PublicRT[count.index].id
}

#-------------------------------------Elastic IP---------------------------------
resource "aws_eip" "standart_nat_eip" {
  count = var.create_resource["network"] ? 1 : 0
  tags = {
    Name        = "${var.resource_owner["name"]}-NAT-EIP"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Stage_Environment"]
  }
}

#--------------------------------NAT Gateway-------------------------------------
resource "aws_nat_gateway" "standart_NATgw" {
  count         = var.create_resource["network"] ? 1 : 0
  allocation_id = aws_eip.standart_nat_eip[count.index].id
  subnet_id     = aws_subnet.standart_public_subnet[count.index].id
  tags = {
    Name        = "${var.resource_owner["name"]}-NAT-GW"
    Owner       = var.resource_owner["owner"]
    Environment = var.resource_owner["Stage_Environment"]
  }
}