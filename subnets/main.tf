resource "aws_subnet" "public" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "production" 
    }
}

resource "aws_subnet" "private1" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-1b"

    tags = {
        Name = "production" 
    }
}

resource "aws_subnet" "private2" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-1c"

    tags = {
        Name = "production" 
    }
}

resource "aws_db_subnet_group" "private" {
  name = "private"
  subnet_ids = [ aws_subnet.private1.id, aws_subnet.private2.id ]

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.public.id 
    route_table_id = var.route_id 
}

resource "aws_network_interface" "net-int-1" {
    subnet_id = aws_subnet.public.id 
    private_ips = var.net_private_ips
    security_groups = [var.security_id] 
}

resource "aws_network_interface" "net-int-2" {
    subnet_id = aws_subnet.public.id 
    private_ips = var.net_private_ips
    security_groups = [var.security_id] 
}

resource "aws_network_interface" "net-int-3" {
    subnet_id = aws_subnet.public.id 
    private_ips = var.net_private_ips
    security_groups = [var.security_id] 
}

resource "aws_eip" "one" {
  vpc = true
  depends_on = [var.internet_gate]
}

resource "aws_nat_gateway" "gw" {
    depends_on = [aws_eip.one]
    allocation_id = aws_eip.one.id 
    subnet_id = aws_subnet.public.id 

    tags = {
        Name = "gw NAT"
    }
}

resource "aws_route_table" "NAT_gateway_RT" {
    depends_on = [aws_nat_gateway.gw]
    vpc_id = var.vpc_id 
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gw.id
    }

    tags = {
        Name = "Route table for NAT Gateway"
    }   
}

resource "aws_route_table_association" "b" {
    subnet_id = aws_subnet.private1.id 
    route_table_id = aws_route_table.NAT_gateway_RT.id
}

resource "aws_route_table_association" "bb" {
    subnet_id = aws_subnet.private2.id 
    route_table_id = aws_route_table.NAT_gateway_RT.id
}