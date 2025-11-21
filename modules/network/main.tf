#---------------------------------standart-VPC----------------------------------
resource "aws_vpc" "standart_vpc" {

  cidr_block       = var.standart_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name        = "${var.resource_owner["name"]} + -VPC"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}

#---------------------------------standart-IGW----------------------------------
resource "aws_internet_gateway" "standart_IGW" {

  vpc_id = aws_vpc.standart_vpc.id
  tags = {
    Name        = "${var.resource_owner["name"]}-IGW"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}

#---------------------------------Public Subnet---------------------------------
resource "aws_subnet" "standart_public_subnet" {

  vpc_id                  = aws_vpc.standart_vpc.id
  cidr_block              = var.standart_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones["az1"]
  tags = {
    Name        = "${var.resource_owner["name"]}-Pub-Subnet"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}

#---------------------------------Private Subnet---------------------------------
resource "aws_subnet" "standart_private_subnet" {

  vpc_id            = aws_vpc.standart_vpc.id
  cidr_block        = var.standart_private_subnet
  availability_zone = var.availability_zones["az1"]
  tags = {
    Name        = "${var.resource_owner["name"]}-Priv-Subnet"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}

#------------------------------------Public Route Table--------------------------
resource "aws_route_table" "standart_PublicRT" {

  vpc_id = aws_vpc.standart_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.standart_IGW.id
  }
  tags = {
    Name        = "${var.resource_owner["name"]}-PubRT"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}

#------------------------------------Private Route Table-------------------------
resource "aws_route_table" "standart_PrivateRT" {

  vpc_id = aws_vpc.standart_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.standart_NATgw.id
  }
  tags = {
    Name        = "${var.resource_owner["name"]}-PrvRT"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Prod_Environment"]}"
  }
}

#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "standart_PublicRTassociation" {

  subnet_id      = aws_subnet.standart_public_subnet.id
  route_table_id = aws_route_table.standart_PublicRT.id
}

#---------------------------------Private Route Table Association----------------
resource "aws_route_table_association" "standart_PrivateRTassociation" {

  subnet_id      = aws_subnet.standart_private_subnet.id
  route_table_id = aws_route_table.standart_PrivateRT.id
}

#---------------------------------sub_Public Subnet---------------------------------
resource "aws_subnet" "standart_sub_public_subnet" {

  vpc_id                  = aws_vpc.standart_vpc.id
  cidr_block              = var.standart_sub_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones["az2"]
}

#------------------------------------sub_Public Route Table--------------------------
resource "aws_route_table" "sub_standart_PublicRT" {

  vpc_id = aws_vpc.standart_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.standart_IGW.id
  }
}


#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "sub_standart_PublicRTassociation" {

  subnet_id      = aws_subnet.standart_sub_public_subnet.id
  route_table_id = aws_route_table.sub_standart_PublicRT.id
}


#-------------------------------------Elastic IP---------------------------------
# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "standart_nat_eip" {

  vpc = true
  tags = {
    Name        = "${var.resource_owner["name"]}-NAT-EIP"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Stage_Environment"]}"
  }
}

#--------------------------------NAT Gateway-------------------------------------
# Create the NAT Gateway using the Elastic IP in the public subnet
resource "aws_nat_gateway" "standart_NATgw" {

  allocation_id = aws_eip.standart_nat_eip.id
  subnet_id     = aws_subnet.standart_public_subnet.id
  tags = {
    Name        = "${var.resource_owner["name"]}-NAT-GW"
    Owner       = "${var.resource_owner["owner"]}"
    Environment = "${var.resource_owner["Stage_Environment"]}"
  }
}

