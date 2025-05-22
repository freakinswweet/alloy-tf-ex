# Suved Alloy Terraform Deploy Project

# AWS Environment For Hosting Application With RDS Datastore

This project showcases the use of Terraform to deploy AWS compute infrastructure with a datastore that can be used for deploying an application. 

It deploys an Elastic Beanstalk application running on EC2 instances, with an RDS database as the data store. 

## Features

- **Elastic Beanstalk Environment**: Manages EC2 instances for application deployment.
- **RDS Database**: Provides a managed relational database backend.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configured with appropriate credentials
- An AWS account

## Notes

- Ensure your AWS credentials have sufficient permissions. This will typically be an IAM role permissioned to allow the user the ability provision and manage resources in:

        - EC2
        - RDS


    As I am unfamiliar with Alloy's IAM setup, I have left generic notes here. 

## Resources Created

- Elastic Beanstalk Application & Environment
- EC2 Instances (managed by Beanstalk)
- RDS Instance (PostgreSQL/MySQL)
