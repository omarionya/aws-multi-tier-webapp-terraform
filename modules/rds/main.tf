resource "aws_db_subnet_group" "db_sbgp" {
    name ="app-db-subnet-group"
    subnet_ids = var.db_subnet_ids

    tags=merge(var.tags,{Name="app-db-subnet-group"})
}

resource "aws_db_instance" "db_ins" {
    identifier ="app-db"
    engine=var.engine
    engine_version = var.engine_version
    instance_class = var.instance_class
    allocated_storage = var.allocated_storage
    db_name = var.db_name
    username=var.db_username
    password = var.db_password

    db_subnet_group_name = aws_db_subnet_group.db_sbgp.name
    vpc_security_group_ids = [var.db_sg_id]

    multi_az = true
    storage_encrypted = true
    publicly_accessible = false

    skip_final_snapshot = true
    deletion_protection = false

    backup_retention_period = 7

    tags=merge(var.tags, {Name="app-db"})

}

