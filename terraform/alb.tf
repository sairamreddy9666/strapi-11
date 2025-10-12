resource "aws_lb" "LB" {
  name               = "LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.LB_SG.id]
  subnets            = ["subnet-01b9145f78073bb17", "subnet-03d2b77588f67313d", "subnet-0e0fe86cf5f4b935b"]

  tags = {
    Name = "sairam-LB"
  }
}

resource "aws_alb_listener" "Listener" {
  load_balancer_arn = aws_lb.LB.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.TG.id
    type             = "forward"
  }
}
