# ALB security Group

resource "aws_security_group" "alb_sg"{
    name ="alb-sg"
    description = "Allow HTTP/HTTPS from anywhere"
    vpc_id=var.vpc_id

    ingress {
        description ="HTTP from anywhere"
        from_port=80
        to_port=80
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    ingress {
        description ="HTTPS from anywhere"
        from_port=443
        to_port=443
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    egress{
        description ="Allow all outbount"
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks =["0.0.0.0/0"]
    }
    tags = merge(var.tags,{Name="alb-sg"})
}
# app EC2 Security Group
resource "aws_security_group" "app_sg" {
    name="app-sg"
    description="Allow traffic from ALB only"
    vpc_id=var.vpc_id

    ingress {
        description ="Allow HTTP from ALB"
        from_port = 80
        to_port=80
        protocol="tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }
    egress {
        description ="Allow all outbound"
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


    tags =merge(var.tags,{Name="app-sg"})


}

#DB security Group

resource "aws_security_group" "db_sg"{
    name="db-sg"
    description="Allow traffic from APP SG only"
    vpc_id=var.vpc_id


    ingress {
        description="Allow  MYSQL FROM APP"
        from_port=3306
        to_port=3306
        protocol="tcp"
        security_groups=[aws_security_group.app_sg.id]



    }

    egress {
        description ="Allow all outbout"
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags =merge(var.tags,{Name="db-sg"})
}