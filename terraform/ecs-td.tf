resource "aws_ecs_task_definition" "TD" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = data.aws_iam_role.ecs_task_exec_role.arn

  container_definitions = jsonencode([
    {
      name      = "strapi-container"
      image     = "242201300764.dkr.ecr.ap-south-1.amazonaws.com/sairam-strapi-ecr:latest"
      cpu       = 1024
      memory    = 2048
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
        { name = "DATABASE_PASSWORD", value = var.db_password },
        { name = "NODE_ENV", value = "production" },
        { name = "JWT_SECRET", value = "jwtsecret" },
        { name = "ADMIN_JWT_SECRET", value = "adminsecret" },
        { name = "API_TOKEN_SALT", value = "randomsalt" },
        { name = "APP_KEYS", value = "key1,key2,key3" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/strapi"
          "awslogs-region"        = "ap-south-1"
          "awslogs-stream-prefix" = "strapi"
        }
      }
    }
  ])
}

