# Suved Alloy Terraform Project
# AWS Application Environment Provisioning

This project provisions an AWS application environment using Terraform. It deploys an Elastic Beanstalk application running on EC2 instances, with an RDS database as the data store. An Application Load Balancer (ALB) is set up for future web application traffic, and a Web Application Firewall (WAF) is attached for enhanced security.

## Features

- **Elastic Beanstalk Environment**: Manages EC2 instances for application deployment.
- **RDS Database**: Provides a managed relational database backend.
- **Application Load Balancer (ALB)**: Handles incoming web traffic and distributes it to EC2 instances.
- **AWS WAF**: Protects the application from common web exploits.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configured with appropriate credentials
- An AWS account

## Notes

- Ensure your AWS credentials have sufficient permissions. This will typically be an IAM role permissioned to allow the user the ability provision and manage resources in:
        * EC2
        * RDS
        * ALB
        * WAF

    As I am unfamiliar with Alloy's IAM setup, I have left generic notes here. 

- The ALB and WAF is provisioned for future application use. Since the prompt states that this environment will be used in the future to run an application, I have deployed an ALB and WAF.

## Resources Created

- Elastic Beanstalk Application & Environment
- EC2 Instances (managed by Beanstalk)
- RDS Instance (PostgreSQL/MySQL)
- Application Load Balancer (ALB)
- AWS WAF Web ACL

