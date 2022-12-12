**Terrraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It is used to define and provision a complete infrastructure using a declarative language. IaC helps businesses automate their infrastructures by programmatically managing an entire technology stack through code.**


# Terraform core concepts:
* Variables: Also used as input-variables, it is key-value pair used by Terraform modules to allow customization.
* Provider: It is a plugin to interact with APIs of service and access its related resources. (We will be using AWS for this project)
* Module: It is a folder with Terraform templates where all the configurations are defined.
* Resources: refers to a block of one or more infrastructure objects (compute instances, virtual networks, etc.), which are used in configuring and managing the infrastructure.
* Output Values: These are return values of a terraform module that can be used by other configurations.
* Plan: It is one stage where it determines what needs to be created, updated, or destroyed.
* Apply: It is the last stage where it applies the changes of the infrastructure in order to move to the desired state.

# Two Tier Infrastructure AWS
* ec2alb - two EC2 instances and Application Load Balancer
* igwrout - Internet Gateway, Route table, Route Table Association
* main - Configure AWS provider
* rds - MySQL database, Database Subnet group, Security group for database.
* sg - Security groups for VPC, ALB.
* vpc - Create VPC, 2 Public Subnet, 2 Private Subnet.