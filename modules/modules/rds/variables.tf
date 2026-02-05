variable "db_subnet_ids" {
    type=list(string)
}
variable "db_sg_id" {
    type =string
}
variable "db_name" {
    type=string
}
variable "db_username" {
    type=string
}
variable "db_password" {
    type =string
    sensitive =true
}
variable "instance_class" {
    type=string
    default="db.t3.micro"
}
variable "engine" {
    type=string
    default="mysql"
}
variable "engine_version" {
    type=string
    default="8.0"
}
variable "allocated_storage" {
    type=number
    default=20
}
variable "tags" {
    type=map(string)
    default={}
}