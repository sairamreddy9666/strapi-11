data "aws_iam_role" "ecs_task_exec_role" {
  name = "ecsTaskExecutionRole"
}

resource "aws_iam_role" "CodeDeployRole" {
  name = "CodeDeployRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "CodeDeployRolePolicy" {
  role       = aws_iam_role.CodeDeployRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForECS"
}
