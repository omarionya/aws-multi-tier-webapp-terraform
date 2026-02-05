output "db_endpoint" {
    value=aws_db_instance.db_ins.endpoint
}

output "db_port" {
    value=aws_db_instance.db_ins.port
}
output "db_id" {
    value=aws_db_instance.db_ins.id
}