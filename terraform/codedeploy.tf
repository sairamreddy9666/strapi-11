resource "aws_codedeploy_app" "ECS_App" {
  name = "Strapi-ECS-App"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "ECS_DG" {
  app_name              = aws_codedeploy_app.ECS_App.name
  deployment_group_name = "Strapi-ECS-DG"
  service_role_arn      = data.aws_iam_role.CodeDeployRole.arn

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  ecs_service {
    cluster_name = aws_ecs_cluster.ECS.name
    service_name = aws_ecs_service.ECS-Service.name
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    green_fleet_provisioning_option {
      action = "COPY_AUTO_SCALING_GROUP"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
