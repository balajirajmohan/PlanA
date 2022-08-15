
resource "aws_vpc" "vpc" {
    cidr_block       = var.vpc_cidr_block
    instance_tenancy = var.instance_tenancy

    tags = {
        Name = "vpc"
    }
}

resource "aws_subnet" "pub_subs" {
    count                   = length(var.pub_sub_cidr_block)
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = var.pub_sub_cidr_block[count.index]
    availability_zone       = var.availability_zone[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = format("%s-%s", "pub-sub", var.az_id[count.index])
    }
}

resource "aws_subnet" "pri_subs" {
    count             = length(var.pri_sub_cidr_block)
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = var.pri_sub_cidr_block[count.index]
    availability_zone = var.availability_zone_pri[count.index]

    tags = {
        Name = format("%s-%s", "pri-sub", var.az_id_pri[count.index])
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    
    tags = {
        Name = "IGW"
    }
}

resource "aws_eip" "nat" {
    count = length(var.pri_sub_cidr_block)
    vpc   = true

    tags = {
        Name = format("%s-%s", "nat-eip", var.az_id[count.index])
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    count         = length(var.pri_sub_cidr_block)
    subnet_id     = aws_subnet.pub_subs[count.index].id
    allocation_id = aws_eip.nat[count.index].id

    tags = {
        Name = format("%s-%s", "nat-gateway", var.az_id[count.index])
    }
}

resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "pub-rt"
    }
}

resource "aws_route" "pub_route" {
    route_table_id         = aws_route_table.pub_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id

    depends_on = [aws_route_table.pub_rt]
}

resource "aws_route_table" "pri_rt" {
    count  = length(var.pri_sub_cidr_block)
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = format("%s-%s", "pri-rt", var.az_id[count.index])
    }
}

resource "aws_route" "pri_route" {
    count                  = length(var.pri_sub_cidr_block)
    route_table_id         = aws_route_table.pri_rt[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id

    depends_on = [aws_route_table.pri_rt]
}

resource "aws_route_table_association" "pub_subs_assoc" {
    count          = length(var.pub_sub_cidr_block)
    subnet_id      = aws_subnet.pub_subs[count.index].id
    route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pri_subs_assoc" {
    count          = length(var.pri_sub_cidr_block)
    subnet_id      = aws_subnet.pri_subs[count.index].id
    route_table_id = aws_route_table.pri_rt[count.index].id
}