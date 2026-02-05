resource "aws_iam_role" "ec2_role" {
    name="ec2-app-role"

    assume_role_policy = jsonencode({
        Version="2012-10-17"
        Statement=[{
            Action="sts:AssumeRole"
            Effect="Allow"
            Principal={Service="ec2.amazonaws.com"}
        }]
    })

}
resource "aws_iam_role_policy_attachment" "ssm" {
    role =aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "this" {
    name="ec2-app-instance-profile"
    role=aws_iam_role.ec2_role.name
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners=["amazon"]

    filter {
        name="name"
        values=["al2023-ami-*-x86_64"]
    }
}
resource "aws_launch_template" "this" {
    name_prefix="app-lt-"
    image_id=data.aws_ami.amazon_linux.image_id
    instance_type=var.instance_type

    iam_instance_profile {
        name=aws_iam_instance_profile.this.name
    }
    network_interfaces {
        associate_public_ip_address =false
        security_groups=[var.app_sg_id]
    }
    user_data =base64encode(<<-EOF
            #!/bin/bash
            yum update -y
            yum install -y httpd
            systemctl start httpd
            systemctl enable httpd
            echo "Hello from $(hostname)" > /var/www/html/index.html
            EOF
    )
    tag_specifications {
        resource_type ="instance"
        tags =merge(var.tags,{Name ="app-server"})
    }

}
resource "aws_autoscaling_group" "asg" {
    name ="app-asg"
    vpc_zone_identifier = var.private_subnet_ids
    desired_capacity = var.desired_capacity
    min_size = var.min_size
    max_size = var.max_size
    health_check_type = "ELB"
    health_check_grace_period = 300

    launch_template {
       id =aws_launch_template.this.id
       version="$Latest"
    }

    target_group_arns = [var.target_group_arn]

    tag {
        key ="Name"
        value ="app-asg-instance"
        propagate_at_launch = true
    }
}
