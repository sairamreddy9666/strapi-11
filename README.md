# 🚀 Strapi Blue/Green Deployment on AWS ECS Fargate

This project automates the **Blue/Green deployment** of a Strapi application using **AWS ECS Fargate**, **Terraform**, **GitHub Actions**, and **AWS CodeDeploy**.  
It demonstrates a modern, fully automated CI/CD pipeline with zero downtime deployment.

---

## 🧩 Architecture Overview
```bash
 ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                              GitHub Repository (strapi-10)                                                 │
 │  - Source Code (Strapi App, Dockerfile, Terraform)                                                                         │
 │  - GitHub Actions Workflows (build-push.yml, deploy.yml, destroy.yml)                                                      │
 └────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
                                                      │
                                                      ▼
 ┌───────────────────────────┐     Build & Push       ┌────────────────────────────┐
 │   GitHub Actions (CI/CD)  │ ───────────────────▶   │ AWS Elastic Container Reg. │
 │   • Build Docker Image    │                      │ (ECR)                       │
 │   • Push Image to ECR     │                      │ Stores Versioned Images     │
 └───────────────────────────┘                      └────────────────────────────┘
                                                      │
                                                      ▼
 ┌───────────────────────────┐     Provision Infra    ┌────────────────────────────┐
 │  Terraform (IaC)          │ ───────────────────▶   │ AWS Infrastructure         │
 │  • ECS Cluster (Fargate)  │                      │ • ALB (with Blue/Green TGs) │
 │  • IAM Roles, SGs, etc.   │                      │ • CloudWatch Logs           │
 │  • CodeDeploy Setup       │                      │ • ECS Services              │
 └───────────────────────────┘                      └────────────────────────────┘
                                                      │
                                                      ▼
 ┌───────────────────────────┐     Deploy via         ┌────────────────────────────┐
 │ AWS CodeDeploy (ECS Type) │ ───────────────────▶   │ ECS Service (Fargate)      │
 │ • Blue/Green Deployment   │                      │ Blue = Old Task Set         │
 │ • Canary Strategy (10%)   │                      │ Green = New Task Set        │
 │ • Auto Rollback on Fail   │                      │ Dynamic Traffic Switch      │
 └───────────────────────────┘                      └────────────────────────────┘
                                                      │
                                                      ▼
 ┌───────────────────────────┐     Routes Requests    ┌────────────────────────────┐
 │ Application Load Balancer │ ───────────────────▶   │ Strapi App (Port 1337)     │
 │ (Listeners: 80 / 443)     │                      │ Responds to Client Traffic  │
 │ • Health Checks           │                      │ Using Green Target Group    │
 └───────────────────────────┘                      └────────────────────────────┘
                                                      │
                                                      ▼
 ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                            AWS CloudWatch (Monitoring)                                                      │
 │  • Collects ECS Metrics                                                                                                    │
 │  • Logs from Strapi Containers                                                                                             │
 │  • Used for Alarms and Troubleshooting                                                                                      │
 └────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

## 🏗️ Architecture Overview

- **ECS Cluster** running **Fargate tasks** for Strapi.
- **Application Load Balancer (ALB)** configured with:
  - Two **Target Groups**: Blue (active) and Green (staging).
  - **Listeners** on ports 80 and 443 for traffic routing.
- **RDS** for Strapi database (PostgreSQL).
- **CodeDeploy** for managing ECS Blue/Green deployments.
- **CloudWatch** for logs and monitoring.
- **GitHub Actions** CI/CD pipeline for automatic deployments.

---

## ⚙️ Technologies Used

| Component | Service |
|------------|----------|
| Application | [Strapi](https://strapi.io/) |
| Container | Docker |
| Orchestration | Amazon ECS (Fargate) |
| CI/CD | GitHub Actions + AWS CodeDeploy |
| IaC | Terraform |
| Database | Amazon RDS (PostgreSQL) |
| Monitoring | Amazon CloudWatch |
| Storage | Amazon S3 (for AppSpec & CodeDeploy) |

---

## 📁 Project Structure

```bash
.
├── .github/workflows/
│ ├── build-push.yml # Builds & pushes Docker image to ECR
│ ├── deploy.yml # Triggers Terraform & CodeDeploy ECS deployment
│ └── destroy.yml # Destroys infrastructure
├── terraform/
│ ├── alb.tf # Application Load Balancer setup
│ ├── codedeploy.tf # CodeDeploy app & deployment group
│ ├── ecs.tf # ECS cluster setup
│ ├── ecs-service.tf # ECS Service with Blue/Green deployment
│ ├── ecs-td.tf # ECS Task Definition
│ ├── sg.tf # Security Groups
│ ├── tg.tf # Target Groups
│ ├── cloudwatch.tf # CloudWatch Logs
│ ├── iam.tf # IAM roles/policies
│ ├── provider.tf # AWS provider config
│ ├── backend.tf # Remote backend (S3)
│ ├── outputs.tf # Outputs
│ ├── terraform.tfvars # Variable values
│ └── var.tf # Variable definitions
├── appspec-template.json # CodeDeploy AppSpec template
├── Dockerfile # Strapi app Dockerfile
├── .env # Environment variables
└── README.md
```

---

## ⚙️ Infrastructure Flow

1. **Terraform** provisions:
   - ECS Cluster & Fargate Service  
   - ALB + Blue/Green Target Groups  
   - Security Groups & IAM Roles  
   - CloudWatch Log Group  
   - CodeDeploy App & Deployment Group  

2. **GitHub Actions** automates:
   - Building the Strapi Docker image  
   - Pushing it to Amazon ECR  
   - Running Terraform Apply  
   - Triggering CodeDeploy Blue/Green deployment  

3. **CodeDeploy**:
   - Creates new (Green) task set  
   - Verifies target health  
   - Switches ALB traffic to Green  
   - Terminates old (Blue) task set  

---

## 🔄 CI/CD Workflow

### **1️⃣ build-push.yml**
- Builds the Docker image
- Tags it as `latest`
- Pushes to Amazon ECR

### **2️⃣ deploy.yml**
- Runs Terraform to update ECS & CodeDeploy configs
- Registers new ECS Task Definition
- Generates AppSpec JSON dynamically
- Creates new CodeDeploy deployment
- Performs Blue/Green traffic shift

### **3️⃣ destroy.yml**
- Destroys all AWS resources created by Terraform

---

## 🚀 How to Deploy

### 1️⃣ Clone this repository
```bash
git clone https://github.com/sairamreddy9666/strapi-10.git
cd strapi-10
```
### 2️⃣ Configure Environment Variables

Update .env with your Strapi and DB settings.

### 3️⃣ Push Code to Trigger Deployment

When you push a change (for example a new Docker image or code update):
```bash
git add .
git commit -m "Update Strapi app"
git push origin main
```

GitHub Actions will automatically:

- Build & push the Docker image to ECR

- Run Terraform

- Trigger Blue/Green deployment

---

## 🧩 CodeDeploy Configuration

- Deployment Strategy: `CodeDeployDefault.ECSCanary10Percent5Minutes`

<img width="912" height="349" alt="Screenshot 2025-10-16 082921" src="https://github.com/user-attachments/assets/7583e38f-ef72-4546-a8d3-09664d35e6d8" />


- Run test traffic route setup
- Reroute production traffic to Green
<img width="904" height="345" alt="Screenshot 2025-10-16 083151" src="https://github.com/user-attachments/assets/6fe966c0-04cc-4542-917c-c7c923a6ba62" />

- Auto rollback on failure enabled
- Wait 5 minutes
<img width="905" height="350" alt="Screenshot 2025-10-16 084148" src="https://github.com/user-attachments/assets/8f7f1a25-295d-42be-be42-f894dd848598" />

- Automatically terminates old tasks post successful deployment

---

## ☁️ CloudWatch Integration

- ECS logs are streamed to CloudWatch under /ecs/strapi

- ALB and ECS metrics tracked for health and performance

<img width="960" height="231" alt="Screenshot 2025-10-16 083513" src="https://github.com/user-attachments/assets/8c236fff-282b-499a-a248-f82e36224afc" />

---

## 🎯 Final ECS Deployment Success
<img width="960" height="450" alt="Screenshot 2025-10-16 084352" src="https://github.com/user-attachments/assets/7e5d4667-a1b2-4eff-8126-5e954f266fda" />

---

## 👤 Author

Sai Ram Reddy Badari

📍 Hyderabad, India

💼 Cloud & DevOps Engineer

---
