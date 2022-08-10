terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}
locals {
  mytag="tf-capstone"
  mytype="t2.nano"
}

resource "aws_instance" "web-server" {
  ami = var.ec2-ami
  #ami           = "ami-08d4ac5b634553e16"
  instance_type = local.mytype
  key_name      = "xxxxxxxxxx"
  tags = {
    Name = "${local.mytag}-instance"
  }
  # user_data = <<-EOF
  #                 #!/bin/bash
  #                 yum update -y
  #                 yum install -y httpd
  #                 systemctl start httpd
  #                 systemctl enable httpd
  #                 ec2id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  #                 echo "<center><h1>The Instance Id of Amazom Linux is ec2id</h1></center>" > /var/www/html/index.txt
  #                 sed "s/ec2id/$ec2id/" /var/www/html/index.txt > /var/www/html/index.html

  #               EOF
}

resource "aws_s3_bucket" "tfs3" {
  #bucket = "${var.s3-name}-${count.index}-dev"
  #count = var.num_of_buckets
  #count = var.num_of_buckets != 0 ? var.num_of_buckets:3  # esitse sol taraf degilse sag taraf
  for_each = toset(var.users)
  bucket = "${each.value}-devops-team-member"
  tags = {
    Name = "${local.mytag}-s3"
  }
}
resource "aws_iam_user" "newusers" {
  for_each = toset(var.users)
  name = each.value
  
}