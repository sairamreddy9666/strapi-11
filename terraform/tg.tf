resource "aws_lb_target_group" "TG" {
  name        = "TG"
  port        = "1337"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-04199d5cf351c2e08"

  tags = {
    Name = "sairam-TG"
  }

  health_check {
    path                = "/admin"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

}
