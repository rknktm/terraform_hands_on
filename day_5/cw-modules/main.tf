provider "aws" {
  region = "us-east-1"
}

module "docker_instance" {
    source = "rknktm/docker-instance/aws"
    key_name = "virgin"
    tag = "alo"
}

output "puip" {
value =module.docker_instance.instance_public_ip
}
