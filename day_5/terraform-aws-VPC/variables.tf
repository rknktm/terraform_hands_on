variable "Project" {
  default = "Terraform-Project"
  description = "Project name"
}
variable "Region" {
  default = "us-east-1"
  description = "AWS-Region"
}
variable "VPC-cidr-block" {
  default = "10.6.0.0/16"
description = "Cidr-block of VPC"  
}
variable "PublicSubnet1-cidr-block" {
  default = "10.6.1.0/24"
description = "Cidr-block of Subnet" 
}
variable "PublicSubnet2-cidr-block" {
  default = "10.6.2.0/24"
description = "Cidr-block of Subnet"  
}
variable "PublicSubnet3-cidr-block" {
  default = "10.6.3.0/24"
description = "Cidr-block of Subnet"  
}
variable "PrivateSubnet1-cidr-block" {
  default = "10.6.11.0/24"
description = "Cidr-block of Subnet"  
}
variable "PrivateSubnet2-cidr-block" {
  default = "10.6.22.0/24"
description = "Cidr-block of Subnet"  
}
variable "PrivateSubnet3-cidr-block" {
  default = "10.6.33.0/24"
description = "Cidr-block of Subnet"  
}
