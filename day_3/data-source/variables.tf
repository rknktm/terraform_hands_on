variable "ec2-type" {
default = "t2.micro"

}
variable "ec2-name" {
default = "eco-server"

}
variable "ec2-ami" {
  default = "ami-090fa75af13c156b4"

}
variable "s3-name" {
  default = "eco7777"

}

variable "num_of_buckets" {
  default = 2
}

variable "users" {
  default = ["santino", "michael", "fredo"]
}