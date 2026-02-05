output "vpc_id"{
   value= aws_vpc.imara_vpc.id
}
output "public_subnet_ids"{
    value=aws_subnet.public[*].id
}
output "private_subnet_ids"{
    value=aws_subnet.private_app[*].id
}
output "private_db_subnet_ids"{
    value=aws_subnet.private_db[*].id
}
output "igw_id"{
    value=aws_internet_gateway.imara_igw.id
}
output "nat_gateway_ids"{
    value=aws_nat_gateway.nat_gw[*].id
}
output "public_route_table_ids"{
    value=aws_route_table.public.id
}
output "private_route_table_ids"{
    value=aws_route_table.private[*].id
}
output "cidr_block"{
    value=aws_vpc.imara_vpc.cidr_block
}
