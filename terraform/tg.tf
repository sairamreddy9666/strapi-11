# Blue Target Group
resource "aws_lb_target_group" "Blue_TG" {
  name        = "Blue-TG"
  port        = "1337"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-04199d5cf351c2e08"

  tags = {
    Name = "sairam-Blue-TG"
  }

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Green Target Group
resource "aws_lb_target_group" "Green_TG" {
  name     = "Green-TG"
  port     = 1337
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "vpc-04199d5cf351c2e08"

  tags = {
    Name = "sairam-Green-TG"
  }

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
