output "beanstalk_url" {
  # This shows the derfault URL you can use to access the future web application once deployed.
  value = aws_elastic_beanstalk_environment.prod.cname
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "rds_username" {
  value     = aws_db_instance.main.username
  sensitive = true
}