# 🚀 Strapi Blue/Green Deployment on AWS ECS Fargate — Task #11

This task extends **Task #10** by adding a **fully automated GitHub Actions CI/CD pipeline** that:
- Pushes pre-built Docker images to ECR,
- Dynamically updates ECS Task Definitions,
- Triggers **AWS CodeDeploy** for Blue/Green deployment,
- Optionally monitors deployment status and rollbacks automatically on failure.

---

## 🧩 Architecture Overview

```bash
 ┌────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
 │                                              GitHub Repository (strapi-11)                                                 │
 │  - Source Code (Strapi App, Dockerfile, Terraform)                                                                         │
 │  - GitHub Actions Workflows (build-push.yml, deploy.yml, destroy.yml)                                                      │
 └────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
                                                      │
                                                      ▼
 ┌───────────────────────────┐     Build & Push       ┌────────────────────────────┐
 │   GitHub Actions (CI/CD)  │ ───────────────────▶   │ AWS Elastic Container Reg. │
 │   • Build Docker Image    │                      │ (ECR)                       │
 │   • Push Image to ECR     │                      │ Stores Versioned Images     │
 │   • Trigger Deployment    │                      └────────────────────────────┘
 │   • Monitor Rollback      │
 └───────────────────────────┘
                                                      │
                                                      ▼
 ┌───────────────────────────┐     Deploy via         ┌────────────────────────────┐
 │ AWS CodeDeploy (ECS Type) │ ───────────────────▶   │ ECS Service (Fargate)      │
 │ • Blue/Green Deployment   │                      │ Blue = Old Task Set         │
 │ • Canary 10%/5min rollout │                      │ Green = New Task Set        │
 │ • Auto Rollback on Fail   │                      │ Managed via ALB Listener    │
 └───────────────────────────┘                      └────────────────────────────┘

```
---

## 🏗️ Key Additions in Task #11

| Feature                                | Description                                                   |
| -------------------------------------- | ------------------------------------------------------------- |
| **GitHub Actions CI/CD**               | Automates the full deployment pipeline.                       |
| **ECR Image Tagging**                  | Uses the GitHub Commit SHA as the image tag.                  |
| **Dynamic ECS Task Definition Update** | Automatically replaces container image URI during deployment. |
| **CodeDeploy Integration**             | Triggers ECS Blue/Green deployment automatically.             |
| **Deployment Monitoring**              | Waits for CodeDeploy to confirm success or rollback.          |


---

## ⚙️ Workflow Logic (GitHub Actions)

## 1️⃣ Build & Push Stage

- From Task #10 (build-push.yml)

- Builds and pushes the Docker image to ECR, tagged with GITHUB_SHA

## 2️⃣ Deploy Stage (Task #11 focus)

- Handled via deploy.yml workflow.
## Key Steps:
1. **Configure AWS Credentials**
2. **Terraform Apply**
  - Ensures ECS, ALB, and CodeDeploy are ready.
3. **Update ECS Task Definition**
  - Dynamically replaces image URI with new commit tag.
4. **Register New Task Revision**
  - Registers a new revision in ECS automatically.
5. **Trigger CodeDeploy**
  - Creates a Blue/Green deployment using the latest task definition.
6. **Monitor Deployment**
  - Waits until deployment is marked successful.


---

## 🧠 Optional Rollback Logic

If the deployment fails:

- **CodeDeploy** automatically reverts ALB traffic to the previous (Blue) target group.

- **GitHub Actions** logs will show:
```bash
Waiter DeploymentSuccessful failed: Waiter encountered a terminal failure state
```
- Rollback details available under **AWS CodeDeploy → Deployments → Events**

---

## 🧾 GitHub Secrets Required

| Secret Name             | Description              |
| ----------------------- | ------------------------ |
| `AWS_ACCESS_KEY_ID`     | IAM User Key             |
| `AWS_SECRET_ACCESS_KEY` | IAM User Secret          |
| `AWS_REGION`            | Region (e.g. ap-south-1) |
| `DB_PASSWORD`           | Database password        |
| `POSTGRES_PASSWORD`     | Optional DB secret       |


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

<img width="910" height="341" alt="Screenshot 2025-10-16 140140" src="https://github.com/user-attachments/assets/a6432dce-e1ba-419d-a5e5-c99c67cd17a5" />

- Run test traffic route setup
- Reroute production traffic to Green

<img width="908" height="340" alt="Screenshot 2025-10-16 140808" src="https://github.com/user-attachments/assets/41a6a066-cadd-4a3e-b12e-d9b62fc02946" />

- Auto rollback on failure enabled
- Wait 5 minutes

<img width="916" height="344" alt="Screenshot 2025-10-16 141347" src="https://github.com/user-attachments/assets/d74a59c3-9794-44da-a9de-4dab735450c5" />

- Automatically terminates old tasks post successful deployment

---

## ☁️ CloudWatch Integration

- ECS logs are streamed to CloudWatch under /ecs/strapi

- ALB and ECS metrics tracked for health and performance

<img width="960" height="231" alt="Screenshot 2025-10-16 083513" src="https://github.com/user-attachments/assets/8c236fff-282b-499a-a248-f82e36224afc" />

---

## 🎯 Final ECS Deployment Success

<img width="960" height="453" alt="Screenshot 2025-10-16 141528" src="https://github.com/user-attachments/assets/8b2a5ae8-a513-47e1-8f3b-b4f19de2e1a4" />

---

## 👤 Author

Sai Ram Reddy Badari

📍 Hyderabad, India

💼 Cloud & DevOps Engineer

---
