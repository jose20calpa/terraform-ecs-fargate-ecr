variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "ecs_taller_Angular" {
  description = "proyecto angular usando ecs y fargate"
  type        = string
  default     = "angular-app"
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}