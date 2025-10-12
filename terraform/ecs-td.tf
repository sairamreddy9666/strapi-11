resource "aws_ecs_task_definition" "TD" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096
  execution_role_arn       = aws_iam_role.ecs_task_exec_role.arn

  container_definitions = jsonencode([
    {
      name      = "strapi-container"
      image     = "${var.ecr_repository_url}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
        }
      ]
      environment = [
        { name = "DATABASE_CLIENT",  value = "postgres" },
        { name = "DATABASE_HOST",    value = var.db_host },
        { name = "DATABASE_PORT",    value = var.db_port },
        { name = "DATABASE_NAME",    value = var.db_name },
        { name = "DATABASE_USERNAME", value = var.db_user },
        { name = "DATABASE_PASSWORD", value = var.db_password }
      ]
    }
  ])
}
