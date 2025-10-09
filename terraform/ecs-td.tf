container_definitions = jsonencode([
  {
    name      = "strapi-app"
    image     = "${var.ecr_repository_url}:${var.image_tag}"
    portMappings = [
      {
        containerPort = 1337
        hostPort      = 1337
      }
    ]
    environment = [
      { name = "DATABASE_HOST", value = var.db_host },
      { name = "DATABASE_PORT", value = var.db_port },
      { name = "DATABASE_NAME", value = var.db_name },
      { name = "DATABASE_USERNAME", value = var.db_user },
      { name = "DATABASE_PASSWORD", value = var.db_password }
    ]
  }
])
