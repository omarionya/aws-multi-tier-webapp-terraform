
# VPC
resource "aws_vpc" "imara_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags =merge(var.tags, {Name = "imara-vpc"})
}

# Imara internet Gateway
resource "aws_internet_gateway" "imara_igw" {
  vpc_id = aws_vpc.imara_vpc.id

  tags = merge(var.tags, {Name ="imara-igw"})
}
# Public subnet
resource "aws_subnet" "public" {
    count = length (var.public_subnet_cidrs)
    vpc_id = aws_vpc.imara_vpc.id
    cidr_block=var.public_subnet_cidrs[count.index]
    availability_zone = var.azs[count.index]
    map_public_ip_on_launch = true

    tags = merge(var.tags,{Name = "public-subnet-${count.index + 1}"})

  }

# Private - APP subnet
resource "aws_subnet" "private_app" {
    count = length (var.private_subnet_cidrs)
    vpc_id =aws_vpc.imara_vpc.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = var.azs[count.index]

    tags = merge(var.tags,{Name="private-app-subnet-${count.index +1}"})

}
# Privae DB subnet
resource "aws_subnet" "private_db" {
    count = length(var.private_db_subnet_cidrs)
    vpc_id=aws_vpc.imara_vpc.id
    cidr_block = var.private_db_subnet_cidrs[count.index]
    availability_zone = var.azs[count.index]


    tags=merge(var.tags,{Name="private-db-subnet-${count.index +1}"})
}
# Public Route Table
resource "aws_route_table" "public" {
    vpc_id=aws_vpc.imara_vpc.id

    route {
        cidr_block ="0.0.0.0/0"
        gateway_id=aws_internet_gateway.imara_igw.id
     }

     tags=merge(var.tags,{Name="public-rt"})

}
#Associate public subnets to the route table
resource "aws_route_table_association" "public" {
    count =length(aws_subnet.public)
    subnet_id=aws_subnet.public[count.index].id
    route_table_id=aws_route_table.public.id
}

# Elastic IPs number equivalent to NAT gateways
resource "aws_eip" "nat_eip" {
    count =var.enable_nat_gateway ? (var.single_nat_gateway ? 1:length(var.azs)):0

    tags=merge(var.tags, {Name="nat-eip-${count.index +1}"})
}
resource "aws_nat_gateway" "nat_gw"{
    count=var.enable_nat_gateway ? (var.single_nat_gateway ? 1:length(var.azs)):0
    allocation_id=aws_eip.nat_eip[count.index].id
    subnet_id=aws_subnet.public[var.single_nat_gateway ? 0:count.index].id

    tags=merge(var.tags,{Name="nat-gateway-${count.index +1}"})

}

# Private Route Tables
resource "aws_route_table" "private"{
    count =length(var.azs)
    vpc_id=aws_vpc.imara_vpc.id

    route{
        cidr_block ="0.0.0.0/0"
        nat_gateway_id=var.enable_nat_gateway ? aws_nat_gateway.nat_gw[count.index].id:null
    }
    tags=merge(var.tags, {Name="private-rt-${count.index +1}"})
}

#Associate Private app and DB to route tables
resource "aws_route_table_association" "private_app"{
    count =length(aws_subnet.private_app)
    subnet_id=aws_subnet.private_app[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "private_db"{
    count =length(aws_subnet.private_db)
    subnet_id=aws_subnet.private_db[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}