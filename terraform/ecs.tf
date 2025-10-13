resource "aws_ecs_cluster" "ECS" {
  name = "sairam-ECS"

  tags = {
    Name = "sairam-ECS"
  }
}
