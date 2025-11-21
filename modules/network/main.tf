#---------------------------------standarts-VPC----------------------------------
resource "aws_vpc" "standarts_vpc" {


  cidr_block       = var.standarts_vpc_cidr
  instance_tenancy = "default"
  tags             = { Name = "standart_VPC" }
}

#---------------------------------standarts-IGW----------------------------------
resource "aws_internet_gateway" "standarts_IGW" {

  vpc_id = aws_vpc.standarts_vpc.id
  tags   = { Name = "standarts_IGW" }
}

#---------------------------------Public Subnet---------------------------------
resource "aws_subnet" "standarts_public_subnet" {

  vpc_id                  = aws_vpc.standarts_vpc.id
  cidr_block              = var.standarts_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.region
  tags                    = { Name = "standarts_Public_subnet" }
}

#---------------------------------Private Subnet---------------------------------
resource "aws_subnet" "standarts_private_subnet" {

  vpc_id            = aws_vpc.standarts_vpc.id
  cidr_block        = var.standarts_private_subnet
  availability_zone = var.region
  tags              = { Name = "standarts_Private_subnet" }
}

#------------------------------------Public Route Table--------------------------
resource "aws_route_table" "standarts_PublicRT" {

  vpc_id = aws_vpc.standarts_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.standarts_IGW.id
  }
  tags = { Name = "standarts_PublicRT" }
}

#------------------------------------Private Route Table-------------------------
resource "aws_route_table" "standarts_PrivateRT" {

  vpc_id = aws_vpc.standarts_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.standarts_NATgw.id
  }
  tags = { Name = "standarts_PrivateRT" }
}

#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "standarts_PublicRTassociation" {

  subnet_id      = aws_subnet.standarts_public_subnet.id
  route_table_id = aws_route_table.standarts_PublicRT.id
}

#---------------------------------Private Route Table Association----------------
resource "aws_route_table_association" "standarts_PrivateRTassociation" {

  subnet_id      = aws_subnet.standarts_private_subnet.id
  route_table_id = aws_route_table.standarts_PrivateRT.id
}

#---------------------------------sub_Public Subnet---------------------------------
resource "aws_subnet" "standarts_sub_public_subnet" {

  vpc_id                  = aws_vpc.standarts_vpc.id
  cidr_block              = var.standarts_sub_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b" # Adjust as needed
  tags                    = { Name = "sub_standarts_Public_subnet" }
}

#------------------------------------sub_Public Route Table--------------------------
resource "aws_route_table" "sub_standarts_PublicRT" {

  vpc_id = aws_vpc.standarts_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.standarts_IGW.id
  }
  tags = { Name = "sub_standarts_PublicRT" }
}


#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "sub_standarts_PublicRTassociation" {

  subnet_id      = aws_subnet.standarts_sub_public_subnet.id
  route_table_id = aws_route_table.sub_standarts_PublicRT.id
}


#-------------------------------------Elastic IP---------------------------------
# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "standarts_nat_eip" {

  vpc  = true
  tags = { Name = "standarts_nat_eip" }
}

#--------------------------------NAT Gateway-------------------------------------
# Create the NAT Gateway using the Elastic IP in the public subnet
resource "aws_nat_gateway" "standarts_NATgw" {

  allocation_id = aws_eip.standarts_nat_eip.id
  subnet_id     = aws_subnet.standarts_public_subnet.id
  tags          = { Name = "standarts_NATgw" }
}

