output "beanstalk_url" {
  value = aws_elastic_beanstalk_environment.prod.cname
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "waf_log_group" {
  value = aws_cloudwatch_log_group.waf.name
}