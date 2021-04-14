resource "aws_instance" "web-server-instance" {
  ami = var.ami_id 
  instance_type = var.instance_type 
  availability_zone = var.av_zone 
  key_name = var.key_name


  network_interface {
    network_interface_id = var.net_id
    device_index = 0
  }

  user_data = var.user_data

  tags = {
     Name = "web-server" 
  }
}