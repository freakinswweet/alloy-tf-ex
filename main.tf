# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name        = "infra-datastore-app"
  description = "Infrastructure with a Datastore for running an application in the future"
}

# EB Environment with ALB
resource "aws_elastic_beanstalk_environment" "prod" {
  name                = "prod-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = var.solution_stack

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.subnets)
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "RetentionInDays"
    value     = "90" # Setting the default retention period for the logs to 90 days. This can be cahnged based on the organization's policy.
  }
}

# RDS Database
resource "aws_db_instance" "main" {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "alloy-example-db-suved-adkar"
  username                = var.db_username # Pulled from the secret.tfvars file or can be specific when the terraform apply command is run
  password                = var.db_password # Pulled from the secret.tfvars file or can be specific when the terraform apply command is run
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "alloy-private-subnet-group" #This is a placeholder name, that should be updated to reflect the Alloy naming convention
  subnet_ids = var.subnets
}

# Security Groups
resource "aws_security_group" "rds" {
  name   = "alloy-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_elastic_beanstalk_environment.prod.setting.aws,autoscaling,launchconfiguration.securitygroups]
  }
}