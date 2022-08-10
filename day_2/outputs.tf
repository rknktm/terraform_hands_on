output "public-ip" {
  value = aws_instance.web-server.public_ip
}
output "private-ip" {
  value = aws_instance.web-server.private_ip
}
# output "s3" {
#   value = aws_s3_bucket.tfs3.*.bucket

# }
output "upper" {
  value = [for x in var.users : upper(x) if length(x) >6 ] 

}
