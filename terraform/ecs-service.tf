resource "aws_ecs_service" "ECS-Service" {
  name                               = "sairam-ecs-service"
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  cluster                            = aws_ecs_cluster.ECS.id
  task_definition                    = aws_ecs_task_definition.TD.arn
  scheduling_strategy                = "REPLICA"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  depends_on                         = [aws_alb_listener.Listener]

  deployment_controller {
    type = "CODE_DEPLOY"
  }


  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.SG.id]
    subnets          = ["subnet-01b9145f78073bb17", "subnet-03d2b77588f67313d", "subnet-0e0fe86cf5f4b935b"]
  }

  lifecycle {
    ignore_changes = [task_definition, platform_version]
  }
}
