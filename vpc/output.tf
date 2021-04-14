output "vpc_id" {
    value = aws_vpc.production.id
}

output "route_id" {
    value = aws_route_table.prod_route.id 
}

output "security_id" {
    value = aws_security_group.allow_web.id
}