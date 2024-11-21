#---------------------------------Defenders-VPC----------------------------------
resource "aws_vpc" "defenders_vpc" {
  cidr_block       = var.defenders_vpc_cidr
  instance_tenancy = "default"
  tags             = { Name = "Defender_VPC" }
}

#---------------------------------Defenders-IGW----------------------------------
resource "aws_internet_gateway" "defenders_IGW" {
  vpc_id = aws_vpc.defenders_vpc.id
  tags   = { Name = "Defenders_IGW" }
}

#---------------------------------Public Subnet---------------------------------
resource "aws_subnet" "defenders_public_subnet" {
  vpc_id                  = aws_vpc.defenders_vpc.id
  cidr_block              = var.defenders_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = var.region
  tags                    = { Name = "Defenders_Public_subnet" }
}

#---------------------------------Private Subnet---------------------------------
resource "aws_subnet" "defenders_private_subnet" {
  vpc_id            = aws_vpc.defenders_vpc.id
  cidr_block        = var.defenders_private_subnet
  availability_zone = var.region
  tags              = { Name = "Defenders_Private_subnet" }
}

#------------------------------------Public Route Table--------------------------
resource "aws_route_table" "defenders_PublicRT" {
  vpc_id = aws_vpc.defenders_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.defenders_IGW.id
  }
  tags = { Name = "Defenders_PublicRT" }
}

#------------------------------------Private Route Table-------------------------
resource "aws_route_table" "defenders_PrivateRT" {
  vpc_id = aws_vpc.defenders_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.defenders_NATgw.id
  }
  tags = { Name = "defenders_PrivateRT" }
}

#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "defenders_PublicRTassociation" {
  subnet_id      = aws_subnet.defenders_public_subnet.id
  route_table_id = aws_route_table.defenders_PublicRT.id
}

#---------------------------------Private Route Table Association----------------
resource "aws_route_table_association" "defenders_PrivateRTassociation" {
  subnet_id      = aws_subnet.defenders_private_subnet.id
  route_table_id = aws_route_table.defenders_PrivateRT.id
}

#---------------------------------sub_Public Subnet---------------------------------
resource "aws_subnet" "defenders_sub_public_subnet" {
  vpc_id                  = aws_vpc.defenders_vpc.id
  cidr_block              = var.defenders_sub_public_subnet
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b" # Adjust as needed
  tags                    = { Name = "sub_Defenders_Public_subnet" }
}

#------------------------------------sub_Public Route Table--------------------------
resource "aws_route_table" "sub_defenders_PublicRT" {
  vpc_id = aws_vpc.defenders_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.defenders_IGW.id
  }
  tags = { Name = "sub_Defenders_PublicRT" }
}


#--------------------------------Public Route Table Association------------------
resource "aws_route_table_association" "sub_defenders_PublicRTassociation" {
  subnet_id      = aws_subnet.defenders_sub_public_subnet.id
  route_table_id = aws_route_table.sub_defenders_PublicRT.id
}


#-------------------------------------Elastic IP---------------------------------
# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "defenders_nat_eip" {
  vpc  = true
  tags = { Name = "defenders_nat_eip" }
}

#--------------------------------NAT Gateway-------------------------------------
# Create the NAT Gateway using the Elastic IP in the public subnet
resource "aws_nat_gateway" "defenders_NATgw" {
  allocation_id = aws_eip.defenders_nat_eip.id
  subnet_id     = aws_subnet.defenders_public_subnet.id
  tags          = { Name = "defenders_NATgw" }
}

