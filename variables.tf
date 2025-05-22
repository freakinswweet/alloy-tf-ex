variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1" #Leaving this as US East 1 as I am based in the NYC area
}

variable "vpc_id" {
  #Here we would specify the VPC we would want to deploay this infrastructure. If the organizationis using only one VPC, this can be hardcoded.
  description = "VPC ID for resources"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
  default = [
    "subnet-0bb1c79dePublic" # This is a placeholder. For the subnets, assuming this is a publically accessible web-app, this would be replaced with Alloy's public subnet.
  ]
}

variable "db_username" {
  description = "RDS username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

variable "solution_stack" {
  description = "Appliaction deployed run application for Alloy's test application"
  default     = "64bit Amazon Linux 2023 v4.3.2 running Docker"
}
