#Provider 
provider "aws" {
  region = "eu-west-1"
}

#VPC
resource "aws_vpc" "myVpc" {
  cidr_block       = "${var.vpc-cidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}
#Internet Gateway
resource "aws_internet_gateway" "myIG" {
  vpc_id = aws_vpc.myVpc.id

  tags = {
    Name = "myIG"
  }
}

#Public Subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.myVpc.id
  cidr_block = "${var.publicsubnet1-cidr}"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.myVpc.id
  cidr_block = "${var.publicsubnet2-cidr}"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet2"
  }
}
#Route table
resource "aws_route_table" "vpcRT" {
  vpc_id     = aws_vpc.myVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIG.id
  }
}
#Route table association
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.vpcRT.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.vpcRT.id
}


#Private Subnet 
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.myVpc.id
  cidr_block = "${var.privatesubnet1-cidr}"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "privatesubnet1"
  }
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.myVpc.id
  cidr_block = "${var.privatesubnet2-cidr}"
  availability_zone = "eu-west-1b"
  tags = {
    Name = "privatesubnet2"
  }
}

#ALB Security Group
resource "aws_security_group" "ALB-SG" {
  name        = "ALB-SG-ACCESS"
  description = "Allow Http/Https inbound traffic"
  vpc_id      = aws_vpc.myVpc.id
  ingress {
    description      = "ALBSecGroup"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ALBSecGroup"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ALB-SG"
  }
}
resource "aws_security_group" "SSH-SG" {
  name        = "SSH-ACCESS"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.myVpc.id

  ingress {
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${var.ssh}"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH-SG"
  }
}
#web tier Security group
resource "aws_security_group" "WEB-SG" {
  name        = "WEB-ACCESS-SG"
  description = "Allow Http/Https inbound traffic only from ALB-SecGroup"
  vpc_id      = aws_vpc.myVpc.id
  ingress {
    description      = "HTTP access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.ALB-SG.id}"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.ALB-SG.id}"]
  }

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.SSH-SG.id}"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "WEB-SG"
  }
}
#Database Security Group
resource "aws_security_group" "Database-SG" {
  name        = "Database-ACCESS-SG"
  description = "Allow Http/Https inbound traffic only from ALB-SecGroup"
  vpc_id      = aws_vpc.myVpc.id
  ingress {
    description      = "MYSQL access"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.WEB-SG.id}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Database-SG"
  }
}

#Web-tier Ec2 Instance
resource "aws_instance" "webim" {
  ami           = "ami-0c1bc246476a5572b"
  instance_type = "t2.micro"
  key_name = "${var.keyname}"
  subnet_id                   = aws_subnet.public1.id
  vpc_security_group_ids      = [aws_security_group.WEB-SG.id]
  associate_public_ip_address = true 
  user_data = <<-EOF
  #!/bin/bash -ex
  amazon-linux-extras install nginx1 -y
  echo "<h1> $(curl http://169.254.169.254/latest/meta-data/public-ipv4</h1>" >  /usr/share/nginx/html/index.html 
  systemctl enable nginx
  systemctl start nginx
  EOF

  tags = {
    Name = "melo"
  }
}
