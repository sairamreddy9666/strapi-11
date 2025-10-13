resource "aws_cloudwatch_log_group" "strapi_log_group" {
  name              = "/ecs/strapi"
  retention_in_days = 7
}
