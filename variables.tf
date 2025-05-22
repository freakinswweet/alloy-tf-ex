variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC ID for resources"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "db_username" {
  description = "RDS admin username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS admin password"
  type        = string
  sensitive   = true
}

variable "solution_stack" {
  description = "Beanstalk solution stack name"
  default     = "64bit Amazon Linux 2023 v4.3.2 running Docker"
}
