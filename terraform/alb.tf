resource "aws_lb" "LB" {
  name               = "LB-BlueGreen"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.LB_SG.id]
  subnets            = ["subnet-01b9145f78073bb17", "subnet-03d2b77588f67313d", "subnet-0e0fe86cf5f4b935b"]

  tags = {
    Name = "sairam-LB-BlueGreen"
  }
}

resource "aws_alb_listener" "Listener" {
  load_balancer_arn = aws_lb.LB.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.Blue_TG.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "Green_Listener" {
  load_balancer_arn = aws_lb.LB.id
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Green_TG.arn
  }
}
