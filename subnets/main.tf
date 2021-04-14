resource "aws_subnet" "public" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.1.0/24"

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
    private_ips = ["10.0.1.50", "10.0.1.51"]
    security_groups = [var.security_id] 
}