resource "aws_security_group" "SG" {
  name        = "sairam-SG"
  description = "Allow all traffic"
  vpc_id      = "vpc-04199d5cf351c2e08"

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sairam-SG"
  }
}
