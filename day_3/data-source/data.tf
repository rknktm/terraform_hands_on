# data "aws_ami" "myTF" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["test-image"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["213114314433"] # Canonical
# }

resource "aws_instance" "web" {
  #ami           = data.aws_ami.myTF.id
  ami           = var.ec2-ami
  instance_type = var.ec2-type

  tags = {
    Name = "${local.tag}-instance"
  }
}

 