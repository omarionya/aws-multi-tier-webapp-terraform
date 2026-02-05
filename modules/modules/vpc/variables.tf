variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
}
variable "azs"{
    description = "list of AZs to deploy resources"
    type  = list (string)
}
variable "public_subnet_cidrs" {
    description = "List of public subnet CIDRs"
    type = list(string)
}
variable "private_subnet_cidrs"{
    description = "List of private app subnet CIDRs"
    type = list(string)
}
variable "private_db_subnet_cidrs"{
    description = "list of private DB subnet CIDRs"
    type =list(string)
}
variable "enable_nat_gateway"{
    description = "Whether to create NAT gateways"
    type = bool
    default = true
}
variable "single_nat_gateway"{
    description = "use a single NAT gateway for all the private subnets"
    type=bool
    default = false
}
variable "tags"{
    description ="Tags to apply to resources"
    type =map(string)
    default={}
}