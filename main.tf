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
}