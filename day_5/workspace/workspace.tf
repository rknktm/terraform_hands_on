provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "tfmyec2" {
    ami = lookup(var.myami, terraform.workspace)
    instance_type = "${terraform.workspace == "dev" ? "t3a.medium" : "t2.micro"}"
    count = "${terraform.workspace == "prod" ? 3 : 1}"
    key_name = "virgin"
    tags = {
      Name = "${terraform.workspace}-server"
    }
  
}

# default = amazon linux 2
# dev = redhat linux 8
# prod = ubuntu 20.04

variable "myami" {
    type = map(string)
    default = {
        default = "ami-090fa75af13c156b4"
        dev     = "ami-06640050dc3f556bb"
        prod    = "ami-08d4ac5b634553e16"
    }
    description = "in order of Amazon Linux 2 ami, Red Hat Enterprise Linux 8 ami and Ubuntu Server 20.04 LTS amis"
}