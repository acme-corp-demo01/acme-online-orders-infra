# ACME Online Orders Infrastructure

This repository demonstrates standardised infrastructure provisioning using Terraform Cloud.

## Objectives

- Standardised provisioning workflows
- Reusable Infrastructure as Code
- Environment isolation through workspaces
- Centralized governance and collaboration

## Environments

- Development
- Staging
- Production

## Future Platform Modules

In a production rollout, ACME's platform team would publish reusable modules into the Terraform Cloud Private Registry, such as:

- network: approved VPC, subnet and routing patterns
- compute: EC2, Auto Scaling Groups and Load Balancers
- database: RDS standard patterns
- storage: S3 buckets with lifecycle and encryption standards
- observability: CloudWatch alarms, dashboards and logging

For this demo, the compute module is implemented locally to demonstrate the reusable module pattern.
