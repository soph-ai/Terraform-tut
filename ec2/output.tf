output "server_private_ip" {
  value = aws_instance.web-server-instance.private_ip
}
output "server_public_ip" {
  value = aws_instance.web-server-instance.public_ip
}
output "server_id" {
  value = aws_instance.web-server-instance.id
}

# jenks 
output "jenks_private_ip" {
  value = aws_instance.jenks-instance.private_ip
}
output "jenks_public_ip" {
  value = aws_instance.jenks-instance.public_ip
}
output "jenks_id" {
  value = aws_instance.jenks-instance.id
}