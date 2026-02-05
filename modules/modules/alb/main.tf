# Application Load Balancer

resource "aws_lb" "app_alb" {
    name="app-alb"
    load_balancer_type = "application"
    security_groups = [var.alb_sg_id]
    subnets=var.public_subnet_ids
    internal=false

    enable_deletion_protection = false

    tags =merge(var.tags,{Name="app-alb"})
}

# Target Group (for EC2 ASG)

resource "aws_lb_target_group" "app_tg" {
    name="app-target-group"
    port=80
    protocol = "HTTP"
    vpc_id=var.vpc_id

    health_check {
       path="/"
       protocol = "HTTP"
       matcher = "200-399"
       interval = 30
       timeout = 5
       healthy_threshold = 2
       unhealthy_threshold = 3
    }

    tags =merge(var.tags, {Name="app-target-group"})


}

# Listener

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.app_alb.arn
    port=80
    protocol = "HTTP"

    default_action {
      type="forward"
      target_group_arn =aws_lb_target_group.app_tg.arn
    }

}