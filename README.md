# 🚀 Strapi Deployment on AWS ECS Fargate Spot (Task #9)

## 📘 Overview
This project deploys a **Strapi application** on **AWS ECS using Fargate Spot** — an optimized version of the Fargate deployment that significantly reduces cost by utilizing AWS spare compute capacity.  
All infrastructure is managed through **Terraform**, and **GitHub Actions** handles the CI/CD automation pipeline.

---

## 🧩 Architecture Components
- **AWS ECS (Fargate Spot)** — Container orchestration service for running Strapi tasks on Spot capacity.
- **ECR (Elastic Container Registry)** — Stores Docker images built from Strapi source.
- **ALB (Application Load Balancer)** — Routes HTTP traffic to the Strapi service.
- **CloudWatch** — Collects ECS container logs and metrics (CPU, Memory, Task count).
- **RDS (PostgreSQL)** — Backend database for Strapi.
- **IAM Roles & Policies** — Provides ECS permissions for ECR, CloudWatch, and networking.
- **Terraform** — Automates provisioning of all AWS resources.
- **GitHub Actions** — Automates Docker build, image push, Terraform apply/destroy.

---

## 🧱 Terraform Resources

| File | Description |
|------|--------------|
| `vpc.tf` | Defines VPC, subnets, and networking setup |
| `sg.tf` | Configures Security Groups for ALB and ECS tasks |
| `alb.tf` | Creates Application Load Balancer and Listener |
| `tg.tf` | Defines Target Group for routing ECS tasks |
| `ecs.tf` | ECS cluster using both **FARGATE** and **FARGATE_SPOT** capacity providers |
| `ecs-td.tf` | ECS Task Definition (with CloudWatch logging configuration) |
| `ecs-service.tf` | ECS Service running tasks using FARGATE_SPOT |
| `cloudwatch.tf` | CloudWatch Log Group for container logs |
| `iam.tf` | IAM roles and policies for ECS task execution |
| `terraform.tfvars` | Variable values (ECR URL, DB config, etc.) |

---


In ecs-service.tf, ECS service references the cluster and task definition:
```hcl
capacity_provider_strategy {
  capacity_provider = "FARGATE_SPOT"
  weight            = 1
}
```

This ensures all tasks use Spot capacity, reducing operational costs.

---


## 🐳 CI/CD Automation via GitHub Actions
Workflows

1. **build-push.yml** — Builds the Strapi Docker image and pushes it to ECR.

2. **deploy.yml** — Runs terraform init, plan, and apply to deploy to ECS.

3. **destroy.yml** — Destroys all AWS resources via Terraform.

Each workflow is triggered on push or workflow_dispatch events.

---

## 📊 Monitoring

CloudWatch is integrated to monitor:

1. **CPU Utilization**

2. **Memory Utilization**

3. **Network In / Out**

4. **ECS Task Count**

5. **Container Logs**

Log group:
```hcl
/ecs/strapi
```

---

## ✅ Verification

To confirm Fargate Spot deployment:

Go to **ECS Console → Cluster → Tasks**

Open a running task.

Verify:
```hcl
Capacity provider: Fargate Spot
Launch type: Fargate
```

---

## 💰 Benefits of Fargate Spot

- **Cost Savings:** Up to 70% cheaper than regular Fargate.

- **Fully Managed:** No need to manage EC2 instances.

- **Seamless Integration:** Works natively with ECS services.

---

## 📂 Repository Structure
```hcl
.github/workflows/
 ├── build-push.yml
 ├── deploy.yml
 └── destroy.yml
terraform/
 ├── alb.tf
 ├── backend.tf
 ├── cloudwatch.tf
 ├── ecs-service.tf
 ├── ecs-td.tf
 ├── ecs.tf
 ├── iam.tf
 ├── outputs.tf
 ├── provider.tf
 ├── sg.tf
 ├── terraform.tfvars
 ├── tg.tf
 ├── var.tf
 └── vpc.tf
Dockerfile
.env
rds-combined-ca-bundle.pem
```

---

## 🧠 Author

**Sai Ram Reddy Badari**

AWS DevOps Project — Task #9: Strapi Deployment using Fargate Spot

GitHub: sairamreddy9666
