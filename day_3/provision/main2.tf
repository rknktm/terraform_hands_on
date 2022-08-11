terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.25.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  security_groups = [ "tf-provisioner-sg" ]
  key_name = "xxxxxxx"

  tags = {
    Name = "terraform-instance-with-provisioner"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > puip.txt"
  }

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("xxxxxxxxxxxxxxxxxxxxxxxxxxx")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  provisioner "file" {
    content      = self.private_ip
    destination = "/home/ec2-user/pri.txt"
  }

}

resource "aws_security_group" "tf-sec-gr" {
  name        = "tf-provisioner-sg"
  description = "Allow HTTP & SSH inbound traffic"
  tags = {
    Name = "tf-provisioner-sg"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
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
  }

}