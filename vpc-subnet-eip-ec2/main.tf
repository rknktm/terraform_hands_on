# Configure the AWS Provider
provider "aws" {
  shared_credentials_files = [ "C:\\Users\\xxx\\.aws\\credentials" ]
  region  = "us-east-1"
}

variable "Subnet_Prefix" {
  description = "Please Enter CIDR Block for Subnet"
  # default = "10.10.66.0/24"
}
# 1. Create vpc
resource "aws_vpc" "VPC" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "tf-vpc"
  }
}
# 2. Create Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "IGW"
  }
}
# 3. Create Custom Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "tf-routetable"
  }
}
# 4. Create a Subnet 
resource "aws_subnet" "PublicSubnet-1" {
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = "10.10.10.0/24"    # var.Subnet_Prefix
  availability_zone = "us-east-1a"
  tags = {
    Name = "tf-subnet"
  }
}
# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PublicSubnet-1.id
  route_table_id = aws_route_table.RT.id
}
# 6. Create Security Group to allow port 22,80,443
resource "aws_security_group" "EC2_SG" {
  name        = "allow_web traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.VPC.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tf_SG"
  }
}
# 7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "ENI" {
  subnet_id       = aws_subnet.PublicSubnet-1.id
  private_ips     = ["10.10.10.50"]
  security_groups = [aws_security_group.EC2_SG.id]

}


# 8. Assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.ENI.id
  associate_with_private_ip = "10.10.10.50"
  depends_on = [aws_internet_gateway.IGW]
  
}
# 9. Create Ubuntu server and install/enable httpd
resource "aws_instance" "web-server" {
  ami           = "ami-xxxxxxxxx"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "xxxxxx"
  network_interface {
    network_interface_id = aws_network_interface.ENI.id
    device_index         = 0
  }

  user_data = <<-EOF
                 #!/bin/bash
                  yum update -y
                  yum install -y httpd
                  systemctl start httpd
                  systemctl enable httpd
                  ec2id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
                  echo "<center><h1>The Instance Id of Amazom Linux is ec2id</h1></center>" > /var/www/html/index.txt
                  sed "s/ec2id/$ec2id/" /var/www/html/index.txt > /var/www/html/index.html
                EOF
   tags = {
     Name = "web-server"
   }
 }

output "server_private_ip" {
   value = aws_instance.web-server.private_ip

 }

output "server_id" {
   value = aws_instance.web-server.id
 }
output "server_public_ip" {
   value = aws_instance.web-server.public_ip

 }