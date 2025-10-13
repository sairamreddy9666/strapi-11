🧱 Strapi on AWS ECS Fargate with Terraform & GitHub Actions

This project automates the deployment of a Strapi application on AWS ECS Fargate using Terraform for infrastructure provisioning and GitHub Actions for CI/CD automation.

Additionally, it integrates Amazon CloudWatch for monitoring and logging.



🚀 Project Overview

Infrastructure managed via Terraform:

ECS Cluster and Fargate Service

Application Load Balancer (ALB)

Target Groups and Listeners

Security Groups

VPC and Subnets (optional / or using existing VPC)

IAM Roles and Policies

CloudWatch Log Groups (for ECS logging)

Optional: CloudWatch Dashboard and Alarms



Automation via GitHub Actions:

build-push.yml – Builds and pushes Strapi Docker image to Amazon ECR

deploy.yml – Deploys latest image to ECS using Terraform

destroy.yml – Destroys AWS infrastructure via Terraform



🧩 Folder Structure

📦 strapi-7

├── .github/workflows/

│   ├── build-push.yml         # CI: Build and push image to ECR

│   ├── deploy.yml             # CD: Deploy infrastructure via Terraform

│   └── destroy.yml            # Destroy environment
│
├── terraform/

│   ├── alb.tf                 # Load Balancer configuration

│   ├── backend.tf             # Terraform backend (S3/DynamoDB)

│   ├── ecs.tf                 # ECS Cluster setup

│   ├── ecs-td.tf              # Task Definition (Strapi container)

│   ├── ecs-service.tf         # ECS Service with Load Balancer

│   ├── sg.tf                  # Security Groups

│   ├── iam.tf                 # IAM Roles & Policies

│   ├── tg.tf                  # Target Group

│   ├── vpc.tf                 # VPC & Subnets (if managed here)

│   ├── provider.tf            # AWS provider setup

│   ├── outputs.tf             # Output ALB DNS, ECS details, etc.

│   ├── terraform.tfvars       # Variable values

│   └── var.tf                 # Variable definitions
│
├── config/

│   ├── admin.js

│   ├── database.js

│   └── server.js              # Strapi configuration
│
├── Dockerfile                 # Builds Strapi image

├── .env                       # Environment variables

├── rds-combined-ca-bundle.pem # SSL certificate for RDS (if used)

├── README.md                  # You are here

└── package.json (if included)



🛠️ Prerequisites

AWS Account with programmatic access (Access Key & Secret)

Terraform ≥ 1.5.x

Docker installed locally

GitHub Secrets configured:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

AWS_REGION

ECR_REPOSITORY

TF_STATE_BUCKET

TF_STATE_LOCK_TABLE



🧪 GitHub Actions Workflows

1️⃣ Build & Push Image (.github/workflows/build-push.yml)

Builds and pushes Strapi Docker image to AWS ECR.

on:

  push:
  
    branches: [ main ]


Outputs:

Docker image pushed to ECR

Commit SHA tagged image


2️⃣ Deploy Infrastructure (.github/workflows/deploy.yml)

Applies Terraform plan to deploy ECS service and ALB.


3️⃣ Destroy Infrastructure (.github/workflows/destroy.yml)

Tears down ECS, ALB, IAM roles, and associated AWS resources.



🪵 CloudWatch Integration

Log Group: /ecs/strapi

Logs from ECS task container are streamed via awslogs driver

Metrics Monitored:

CPU Utilization

Memory Utilization

Running Task Count

Network In/Out

Optionally, you can add:

CloudWatch Alarms (e.g., high CPU usage > 80%)

Dashboards for ECS metrics visualization



🧰 Useful Terraform Commands

terraform init

terraform plan -out=tfplan

terraform apply -auto-approve tfplan

terraform destroy -auto-approve



🌐 Access Application

After deployment:

Visit ALB DNS name (output from Terraform)

Example:

http://<alb-dns-name>



🧹 Cleanup

To delete all resources and avoid unnecessary AWS charges:

terraform destroy -auto-approve

Or trigger the GitHub Action workflow destroy.yml.



👨‍💻 Author

Sai Ram Reddy Badari

Cloud Engineer | DevOps Enthusiast

📍 Hyderabad, India

🔗 GitHub: @sairamreddy9666
