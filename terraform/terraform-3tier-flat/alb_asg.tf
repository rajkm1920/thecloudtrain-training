# ALB
resource "aws_lb" "alb" {
  name               = "${local.name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in aws_subnet.public : s.id]
  tags = { Name = "${local.name}-alb" }
}

resource "aws_lb_target_group" "tg" {
  name     = "${local.name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 15
    matcher             = "200-399"
  }

  tags = { Name = "${local.name}-tg" }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Get latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Launch Template with user_data that installs nginx
locals {
  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y nginx
    cat > /usr/share/nginx/html/index.html <<HTML
    <html><body>
     <h1>${local.name} - App Server</h1>
     <p>Host: $(hostname)</p>
     </body></html>
    HTML
    systemctl enable nginx
    systemctl start nginx
  EOF
}

resource "aws_launch_template" "lt" {
  name_prefix   = "${local.name}-lt-"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.instance_type

  user_data               = base64encode(local.user_data)
  vpc_security_group_ids  = [aws_security_group.app_sg.id]

  key_name      = var.key_name

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${local.name}-app" }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "asg" {
  name                      = "${local.name}-asg"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = [for s in aws_subnet.app : s.id]
  health_check_type         = "EC2"
  health_check_grace_period = 60

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  tag {
    key                 = "Name"
    value               = "${local.name}-app"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
