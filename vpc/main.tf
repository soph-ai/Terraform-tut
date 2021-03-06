resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "production"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.prod-vpc.id
}

resource "aws_route_table" "prod_route_table" {
    vpc_id = aws_vpc.prod-vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    route {
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "production"
    }
}

resource "aws_security_group" "allow_web" {
    name = "allow_web"
    description = "allow web inbound traffic" 
    vpc_id = aws_vpc.prod-vpc.id

    ingress {
        description = "HTTPS"
        from_port = 443 
        to_port = 443 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port = 80 
        to_port = 80 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port = 22 
        to_port = 22 
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_security_group" "MySQL-SG" {
  description = "MySQL Access ONLY from public instances"
  name = "mysql-sg"
  vpc_id = aws_vpc.prod-vpc.id
  ingress {
    description = "MySQL Access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.allow_web.id]
  }

  egress {
    description = "output from MySQL"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}