variable "vpc_id"{
    description="The VPC ID where security groups will be created"
    type=string
}
variable "tags"{
    description ="Tags to apply to all SGs"
    type=map(string)
    default ={}
}