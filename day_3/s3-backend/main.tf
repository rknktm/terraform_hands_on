# terraform {
#   backend "s3" {
#     bucket = "eco777"
#     key    = "global/s3/terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "tfs3lock"
#     encrypt = true
#   }
# }  
  
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tfs3" {
  bucket = "eco777"
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tfs3.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.tfs3.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "tfs3lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


resource "aws_instance" "web-server" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  key_name = "xxxxxxxxxxx"

  tags = {
    Name = "my_server"
  }
}