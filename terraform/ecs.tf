resource "aws_ecs_cluster" "ECS" {
  name = "sairam-ECS-BlueGreen"

  tags = {
    Name = "sairam-ECS-BlueGreen"
  }
}
