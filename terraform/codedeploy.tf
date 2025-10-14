resource "aws_codedeploy_app" "ECS_App" {
  name = "Strapi-ECS-App"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "ECS_DG" {
  app_name              = aws_codedeploy_app.ECS_App.name
  deployment_group_name = "Strapi-ECS-DG"
  service_role_arn      = aws_iam_role.CodeDeployRole.arn

  deployment_config_name = "CodeDeployDefault.ECSCanary10Percent5Minutes"

  ecs_service {
    cluster_name = aws_ecs_cluster.ECS.name
    service_name = aws_ecs_service.ECS-Service.name
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  load_balancer_info {
    target_group_pair_info {

      # Blue Target Group
      target_group {
        name = aws_lb_target_group.Blue_TG.name
      }

      # Green Target Group
      target_group {
        name = aws_lb_target_group.Green_TG.name
      }

      # Listener ARNs (must be a list)
      prod_traffic_route {
        listener_arns = [aws_alb_listener.Listener.arn]
      }
    }
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                         = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  depends_on = [
    aws_iam_role.CodeDeployRole,
    aws_iam_role_policy_attachment.CodeDeployRolePolicy
  ]
}
