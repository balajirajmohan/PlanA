
output "vpc_id" {
    description = "The VPC id"
    value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
    description = "The VPC CIDR range"
    value       = aws_vpc.vpc.cidr_block
}

output "vpc_default_security_group" {
    description = "The Default security group created in the VPC"
    value       = aws_vpc.vpc.default_security_group_id
}

output "pub_subs_id" {
    description = "The list of public subnet IDs"
    value       = aws_subnet.pub_subs.*.id
}

output "pri_subs_id" {
    description = "The list of private subnet IDs"
    value       = aws_subnet.pri_subs.*.id
}

output "pub_subs_cidr_block" {
    description = "The list of public subnet CIDR blocks"
    value       = aws_subnet.pub_subs.*.cidr_block
}

output "pri_subs_cidr_block" {
    description = "The list of private subnet CIDR blocks"
    value       = aws_subnet.pri_subs.*.cidr_block
}

output "pub_rt_id" {
    description = "The Route table of the public subnets"
    value       = aws_route_table.pub_rt.id
}

output "pri_rt_id" {
    description = "The Route table of the priavte subnets"
    value       = aws_route_table.pri_rt.*.id
}

output "nat_eip" {
    description = "The elastic IP for the nat gateway"
    value       = aws_eip.nat.*.public_ip
}

output "nat_gateway_id" {
    description = "The ID of the nat gateway for the private subnets"
    value       = aws_nat_gateway.nat_gateway.*.id
}