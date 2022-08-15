
# Step 1: Create a VPC
resource "aws_vpc" "myTF-vpc" {
  cidr_block = var.VPC-cidr-block
  enable_dns_hostnames = true
  enable_dns_support = true 
  tags = {
    Name = "${var.Project}-VPC"
  }
}
#################################################################
# Step 2: Create IGW
resource "aws_internet_gateway" "myTF-igw" {
  vpc_id = aws_vpc.myTF-vpc.id

  tags = {
    Name = "${var.Project}-IGW"
  }
}
###################################################################
# Step 3: Create Route Table-Public and Private
resource "aws_route_table" "myTF-Purt" {
  vpc_id = aws_vpc.myTF-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myTF-igw.id
  }
  tags = {
    Name = "${var.Project}-PURT"
  }
}
##############################################################
resource "aws_route_table" "myTF-Prrt" {
  vpc_id = aws_vpc.myTF-vpc.id
  tags = {
    Name = "${var.Project}-PRRT"
  }
}
#################################################################
# Step 4: Create Subnets Public and Private
resource "aws_subnet" "Public1" {
  vpc_id     = aws_vpc.myTF-vpc.id
  cidr_block = var.PublicSubnet1-cidr-block
  availability_zone = "${var.Region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.Project}-PublicSubnet1"
  }
}
##################################################################
resource "aws_subnet" "Public2" {
  vpc_id     = aws_vpc.myTF-vpc.id
  cidr_block = var.PublicSubnet2-cidr-block
  availability_zone = "${var.Region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.Project}-PublicSubnet2"
  }
}
##################################################################
resource "aws_subnet" "Public3" {
  vpc_id     = aws_vpc.myTF-vpc.id
  cidr_block = var.PublicSubnet3-cidr-block
  availability_zone = "${var.Region}c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.Project}-PublicSubnet3"
  }
}
##################################################################
resource "aws_subnet" "Private1" {
  vpc_id     = aws_vpc.myTF-vpc.id
  cidr_block = var.PrivateSubnet1-cidr-block
  availability_zone = "${var.Region}a"

  tags = {
    Name = "${var.Project}-PrivateSubnet1"
  }
}
##################################################################
resource "aws_subnet" "Private2" {
  vpc_id     = aws_vpc.myTF-vpc.id
  cidr_block = var.PrivateSubnet2-cidr-block
  availability_zone = "${var.Region}b"

  tags = {
    Name = "${var.Project}-PrivateSubnet2"
  }
}
##################################################################
resource "aws_subnet" "Private3" {
  vpc_id     = aws_vpc.myTF-vpc.id
  cidr_block = var.PrivateSubnet3-cidr-block
  availability_zone = "${var.Region}c"

  tags = {
    Name = "${var.Project}-PrivateSubnet3"
  }
}
##################################################################
# Step 5: Subnet Associations
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Public1.id
  route_table_id = aws_route_table.myTF-Purt.id
}
##################################################################
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.Public2.id
  route_table_id = aws_route_table.myTF-Purt.id
}
##################################################################
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.Public3.id
  route_table_id = aws_route_table.myTF-Purt.id
}
##################################################################
resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.Private1.id
  route_table_id = aws_route_table.myTF-Prrt.id
}
##################################################################
resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.Private2.id
  route_table_id = aws_route_table.myTF-Prrt.id
}
##################################################################
resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.Private3.id
  route_table_id = aws_route_table.myTF-Prrt.id
}