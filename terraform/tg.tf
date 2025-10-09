resource "aws_lb_target_group" "TG" {
  name        = "TG"
  port        = "1337"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "sairam-TG"
  }
}
