
output "instance-ip-addr" {
  value = aws_instance.web-server.public_ip

}
output "instance-id" {
  value = aws_instance.web-server.id

}

output "private_ip" {
  value = aws_instance.web-server.private_ip

}