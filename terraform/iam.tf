data "aws_iam_role" "ecs_task_exec_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "CodeDeployRole" {
  name = "CodeDeployRole"
}
