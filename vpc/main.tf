resource "aws_vpc" "production" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "production"
    }
}
resource "aws_route_table" "prod_route" {
    vpc_id = aws_vpc.production.id 

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "production"
    }
}

resource "aws_security_group" "allow_web" {
    name = "allow_web"
    description = "allwo web inbound traffic" 
    vpc_id = aws_vpc.production.id

    ingress {
        description = "HTTPS"
        from_port = 443 
        to_port = 443 
        protocol = "tcp"
        cidr_blocks = [aws_vpc.production.cidr_block]
    }

    ingress {
        description = "HTTP"
        from_port = 80 
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = [aws_vpc.production.cidr_block]
    }

    ingress {
        description = "SSH"
        from_port = 22 
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = [aws_vpc.production.cidr_block]
    }

    egress {
        from_port = 0 
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_web_traffic" 
    }
}