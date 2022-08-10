terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source = "integrations/github"
      version = "4.28.0"
    }
  }
}


provider "github" {
  token = "xxxxxxxxxxxxxxxxxxxxxxxxxx"
}



provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "web-server" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.nano"
  key_name = "virgin"

  tags = {
    Name = "my_server"
  }
  user_data = file("userdata.sh")
}

resource "aws_s3_bucket" "tfs3" {
  bucket = "eco77"
  
}

# resource "github_repository" "example" {
#   name        = "example"
#   description = "My awesome codebase"

#   visibility = "public"

# }