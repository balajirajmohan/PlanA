
module "vpc" {
    source                = "../../Modules/terraform-vpc"
    vpc_cidr_block        = var.vpc_cidr_block
    instance_tenancy      = var.instance_tenancy
    pub_sub_cidr_block    = var.pub_sub_cidr_block
    availability_zone     = var.availability_zone
    availability_zone_pri = var.availability_zone_pri
    az_id                 = var.az_id
    az_id_pri             = var.az_id_pri
    pri_sub_cidr_block    = var.pri_sub_cidr_block
}

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "vpc_cidr" {
    value = module.vpc.vpc_cidr
}

output "vpc_default_security_group" {
    value = module.vpc.vpc_default_security_group
}

output "pub_sub_ids" {
    value = module.vpc.pub_subs_id
}

output "pub_sub_cidrs" {
    value = module.vpc.pub_subs_cidr_block
}

output "pri_sub_ids" {
    value = module.vpc.pri_subs_id
}

output "pri_sub_cidrs" {
    value = module.vpc.pri_subs_cidr_block
}

output "pub_rt_id" {
    value = module.vpc.pub_rt_id
}

output "pri_rt_id" {
    value = module.vpc.pri_rt_id
}

output "nat_eip" {
    value = module.vpc.nat_eip
}

output "nat_gateway_id" {
    value = module.vpc.nat_gateway_id
}