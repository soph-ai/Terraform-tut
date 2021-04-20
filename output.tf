output "instance_ip" {
    value = module.ec2.server_public_ip
}

#jenks 
output "instance_ip_2" {
    value = module.ec2.jenks_public_ip
}