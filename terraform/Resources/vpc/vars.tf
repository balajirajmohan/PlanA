
variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = ""
}

variable "instance_tenancy" {
    description = "The tenancy of the VPC"
    type        = string
    default     = "default"
}

variable "pub_sub_cidr_block" {
    description = "The CIDR blocks for the public subnets"
    type        = list
    default     = []
}

variable "availability_zone" {
    description = "The list of AZ's"
    type        = list
    default     = []
}

variable "availability_zone_pri" {
    description = "The list of AZ's"
    type        = list
    default     = []
}

variable "az_id" {
    description = "The list of AZ id for resource tags"
    type        = list
    default     = []
}

variable "az_id_pri" {
    description = "The list of AZ id for resource tags"
    type        = list
    default     = []
}

variable "pri_sub_cidr_block" {
    description = "The CIDR blocks for the private subnets"
    type        = list
    default     = []
}