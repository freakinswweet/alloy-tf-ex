# Elastic Beanstalk Application
resource "aws_elastic_beanstalk_application" "app" {
  name        = "beanstalk-app"
  description = "EB Application with WAF and RDS"
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
    value     = "30"
  }
}

# RDS Database
resource "aws_db_instance" "main" {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "appdb"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds.id]
  db_subnet_group_name    = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = var.subnets
}

# Security Groups
resource "aws_security_group" "rds" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_elastic_beanstalk_environment.prod.setting.aws:autoscaling:launchconfiguration.securitygroups]
  }
}

# WAF & Logging
resource "aws_wafv2_web_acl" "main" {
  name        = "eb-waf-acl"
  scope       = "REGIONAL"
  description = "WAF for Elastic Beanstalk"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action { none {} }
    
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  logging_configuration {
    log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
  }
}

resource "aws_cloudwatch_log_group" "waf" {
  name              = "aws-waf-logs"
  retention_in_days = 90
  kms_key_id        = aws_kms_key.logs.arn
}

resource "aws_kms_key" "logs" {
  description             = "WAF Logs Encryption"
  deletion_window_in_days = 90
}

# WAF ALB Association
resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = aws_elastic_beanstalk_environment.prod.load_balancers[0]
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}
