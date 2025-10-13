resource "aws_ecs_cluster" "ECS" {
  name = "sairam-ECS"

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  tags = {
    Name = "sairam-ECS"
  }
}
