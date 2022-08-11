resource "aws_key_pair" "pro" {
  key_name = "prokey"
  public_key = file("terraform.pub")
}

resource "aws_instance" "web-server" {
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  key_name = aws_key_pair.pro.key_name

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt"
  }

}