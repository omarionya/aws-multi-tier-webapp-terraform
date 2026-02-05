variable "private_subnet_ids"{
    type=list(string)
}
variable "app_sg_id" {
    type=string
}
variable "target_group_arn" {
    type =string
}
variable "instance_type" {
    type=string
    default="t3.micro"
}
variable "desired_capacity" {
    type=number
    default=2
}
variable "min_size"{
    type=number
    default=2
}
variable "max_size" {
    type=number
    default=4
}
variable "tags" {
    type=map(string)
    default ={}
}