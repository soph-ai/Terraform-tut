provider "aws" {
    region = "eu-west-1"
    access_key = var.access_key
    secret_key = var.secret_key
}
module "vpc" {
    source = "./vpc"
}
module "subnets" {
    source = "./subnets"

    vpc_id = module.vpc.vpc_id 
    route_id = module.vpc.route_id
    security_id = module.vpc.security_id 
    internet_gate = module.vpc.internet_gate 
    net_private_ips = ["10.0.1.50"]
}

module "ec2" {
    source = "./ec2"

    net_id = module.subnets.net_id
    ami_id = "ami-08bac620dc84221eb"
    instance_type = "t2.micro"
    av_zone = "eu-west-1a"
    key_name = "ssh-aws-2"
    user_data = <<-EOF
                        #!/bin/bash
                        sudo apt update -y
                        sudo apt install apache2 -y
                        sudo systemctl start apache2
                        sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                        EOF
}