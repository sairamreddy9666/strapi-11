variable "image_tag" {
  description = "Docker image tag pushed to ECR"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}
