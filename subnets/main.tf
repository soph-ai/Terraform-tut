resource "aws_subnet" "public" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "production" 
    }
}

resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.public.id 
    route_table_id = var.route_id 
}

resource "aws_network_interface" "i" {
    subnet_id = aws_subnet.public.id 
    private_ips = var.net_private_ips
    security_groups = [var.security_id] 
}

resource "aws_eip" "one" {
  vpc = true
  network_interface = aws_network_interface.i.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [var.internet_gate]
}