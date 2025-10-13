# 🚀 Strapi Deployment on AWS ECS Fargate (Task #8)

This project automates the deployment of a **Strapi application** on **AWS ECS Fargate** using **Terraform** for infrastructure provisioning, **GitHub Actions** for CI/CD automation, and **AWS CloudWatch** for logging and performance monitoring.

---

## 📋 Project Overview

| Component | Description |
|------------|-------------|
| **Application** | Strapi (Node.js Headless CMS) |
| **Container Platform** | AWS ECS (Fargate Launch Type) |
| **Infrastructure as Code** | Terraform |
| **CI/CD Pipeline** | GitHub Actions |
| **Container Registry** | Amazon ECR |
| **Monitoring & Logging** | AWS CloudWatch |
| **Database** | Amazon RDS (PostgreSQL) |
| **Load Balancer** | Application Load Balancer (ALB) |
| **Network** | Existing VPC and Public Subnets |

---

## 🧱 Architecture Diagram
Developer → GitHub → GitHub Actions CI/CD → AWS ECR → ECS Fargate → ALB → CloudWatch Logs/Metrics

---

## ⚙️ Features Implemented

✅ **Infrastructure Automation with Terraform**
- ECS Cluster, Task Definition, and Service
- ALB with Listener and Target Group
- IAM Roles and Security Groups
- CloudWatch Log Group (`/ecs/strapi`)
- ECS Task Log Driver integrated with CloudWatch

✅ **CI/CD with GitHub Actions**
- Automatically builds Docker image from `Dockerfile`
- Pushes the image to AWS ECR
- Runs Terraform `plan` and `apply` for automated deployment
- Supports `destroy.yml` workflow for cleanup

✅ **CloudWatch Monitoring**
- Logs collected via AWS Logs driver (`/ecs/strapi`)
- Metrics enabled for:
  - CPU Utilization
  - Memory Utilization
  - Network In / Out
  - Running Task Count
- Optional alarms and dashboards can be created for:
  - High CPU or memory usage
  - Unhealthy task count
  - Latency tracking (if enabled)



## 📂 Repository Structure
.
├── .github/workflows/

│ ├── build-push.yml # Build & Push to ECR

│ ├── deploy.yml # Terraform Apply

│ └── destroy.yml # Terraform Destroy

├── terraform/

│ ├── alb.tf

│ ├── backend.tf

│ ├── ecs-service.tf

│ ├── ecs-td.tf

│ ├── ecs.tf

│ ├── iam.tf

│ ├── outputs.tf

│ ├── provider.tf

│ ├── sg.tf

│ ├── terraform.tfvars

│ ├── tg.tf

│ ├── var.tf

│ └── vpc.tf

├── config/

│ ├── admin.js

│ ├── database.js

│ └── server.js

├── Dockerfile

├── .env

├── rds-combined-ca-bundle.pem

└── README.md

---

## 🧩 Terraform Resources Created

| Resource Type | Name | Description |
|----------------|------|-------------|
| `aws_ecs_cluster` | sairam-ECS | ECS Cluster for Strapi |
| `aws_ecs_task_definition` | strapi-task | Defines container specs & logs |
| `aws_ecs_service` | sairam-ecs-service | Runs Fargate tasks |
| `aws_lb` | sairam-LB | Application Load Balancer |
| `aws_lb_target_group` | TG | ALB Target Group for ECS Tasks |
| `aws_alb_listener` | Listener | Routes HTTP traffic to ECS |
| `aws_cloudwatch_log_group` | /ecs/strapi | Captures Strapi logs |
| `aws_security_group` | SG, LB_SG | For ECS and ALB networking |
| `aws_iam_role` | ecs_task_exec_role | ECS Task Execution Role |

---

## 🧠 CloudWatch Observability

### 🔹 Logs
- Navigate to **AWS Console → CloudWatch → Logs → Log Groups → /ecs/strapi**
- Check live application logs from running containers.

### 🔹 Metrics
- **AWS Console → CloudWatch → Metrics → ECS → ClusterName**
- View metrics like:
  - CPUUtilization
  - MemoryUtilization
  - NetworkIn
  - NetworkOut
  - RunningTaskCount

### 🔹 Optional Dashboards / Alarms
You can define dashboards or alarms for:
- CPU > 80% (alarm)
- Memory > 75%
- Failed task count > 0

Example Terraform snippet for alarm (optional):
```hcl
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggered when CPU > 80%"
  dimensions = {
    ClusterName = aws_ecs_cluster.ECS.name
  }
}


---


🚀 Deployment Steps

1️⃣ Clone the Repository
git clone https://github.com/sairamreddy9666/strapi-8.git
cd strapi-8/terraform

2️⃣ Configure AWS Credentials
aws configure

3️⃣ Initialize Terraform
terraform init

4️⃣ Plan and Apply
terraform plan -out=tfplan
terraform apply -auto-approve tfplan

5️⃣ Access Application

Once deployed, copy the Load Balancer DNS Name from Terraform output or AWS Console and open it in your browser:

http://<ALB-DNS-Name>:1337/admin

🧹 Destroy Infrastructure

When done testing, destroy all resources:

terraform destroy -auto-approve

📈 Future Enhancements

Add CloudWatch Alarms and SNS Notifications

Add HTTPS (ACM Certificate + ALB HTTPS Listener)

Integrate Route53 for custom domain

Add Prometheus/Grafana for deep observability

👤 Author

Sai Ram Reddy Badari
AWS | DevOps | Docker | Terraform | Strapi
📍 Hyderabad, India
🔗 GitHub: sairamreddy9666
