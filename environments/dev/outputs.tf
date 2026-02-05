output "alb_dns"{
    value=module.alb.alb_dns_name
}
output "asg_name"{
    value=module.ec2-asg.asg_name
}
output "rds_endpoint"{
    value=module.rds.db_endpoint
}