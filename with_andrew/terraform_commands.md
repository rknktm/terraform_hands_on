terraform init
terraform plan
terraform apply -auto -approve
etrraform destroy
terraform state list
terraform state show xxxx(resource name)
terraform destroy -target name of the resource
terraform apply -target name of the resource
terraform.tfvars ........write the all variables here (default)
example.tfvars ...... terraform apply -var-file example.tfvars
terraform plan -var=InstanceType="t2.micro"   enter info fron terminal

locals {
  projectname="erkan"
}

tags{
  Name = "server-${local.projectname}"
}

outputs "instance-ip-addr"{
value = aws_instance.server-erkan.public_ip

}

terraform output ::::>show outputs written in code

terraform refresh   :::> refresh the state of the  code(when you write new codes and see the result, you must the state refresh by this command)

terraform output public_ip  :::> to see the only  given output in command line (here example for public_ip)

modul icinde ikinci provider
provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}
yukaridaki kismi provider kismina koy
# An example child module is instantiated with the alternate configuration,
# so any AWS resources it defines will use the us-west-2 region.
module "example" {
  source    = "./example"
  providers = {
    aws = aws.usw2
  }
}