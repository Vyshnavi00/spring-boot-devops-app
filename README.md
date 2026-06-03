# Spring Boot DevOps App — AWS ECS Fargate

End-to-end DevOps project deploying a Spring Boot application on AWS ECS Fargate with full CI/CD automation using GitHub Actions and infrastructure provisioned via Terraform.

---

## Architecture

```
Code Push → GitHub Actions CI/CD
          → Build JAR (Maven)
          → Build Docker Image (Multi-stage)
          → Push to Amazon ECR
          → Deploy to AWS ECS Fargate
          → Serve via Application Load Balancer (ALB)
```

---

## Tech Stack

| Category | Tools |
|----------|-------|
| Application | Java 17, Spring Boot 3.x |
| Containerization | Docker (Multi-stage build) |
| Container Registry | Amazon ECR |
| Infrastructure | Terraform (IaC) |
| Orchestration | AWS ECS Fargate |
| Load Balancer | AWS Application Load Balancer |
| CI/CD | GitHub Actions |
| Monitoring | AWS CloudWatch |
| Networking | AWS VPC, Subnets, IGW, Route Tables |
| Security | IAM Roles, Security Groups |

---

## Project Structure

```
spring-boot-devops-app/
├── src/                          # Spring Boot application
│   └── main/java/com/devops/
│       └── AppController.java    # REST endpoints
├── terraform/                    # Infrastructure as Code
│   ├── main.tf                   # AWS provider
│   ├── backend.tf                # S3 remote state
│   ├── variables.tf              # Input variables
│   ├── vpc.tf                    # VPC, subnets, IGW
│   ├── ecr.tf                    # ECR repository
│   ├── iam.tf                    # IAM roles
│   ├── alb.tf                    # Load balancer
│   ├── ecs.tf                    # ECS cluster, service, task
│   └── outputs.tf                # ALB DNS output
├── .github/
│   └── workflows/
│       └── deploy.yml            # CI/CD pipeline
├── Dockerfile                    # Multi-stage build
└── README.md
```

---

## API Endpoints

| Endpoint | Response |
|----------|----------|
| GET / | Spring Boot DevOps App is Running! |
| GET /health | {"status":"healthy","service":"spring-boot-devops-app"} |

---

## Run Locally

### Prerequisites
- Java 17
- Docker

### Steps

```bash
# Clone the repo
git clone https://github.com/Vyshnavi00/spring-boot-devops-app.git
cd spring-boot-devops-app

# Build and run with Docker (no need to run mvn separately)
docker build -t spring-boot-devops-app .
docker run -d -p 8080:8080 --name devops-app spring-boot-devops-app

# Test
curl http://localhost:8080/
curl http://localhost:8080/health
```

---

## Deploy to AWS

### Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform installed
- S3 bucket for Terraform remote state
- DynamoDB table for state locking

### Steps

```bash
# 1. Provision all AWS infrastructure
cd terraform
terraform init
terraform plan
terraform apply

# 2. Push Docker image to ECR
aws ecr get-login-password --region ap-south-2 | \
  docker login --username AWS --password-stdin \
  <your-account-id>.dkr.ecr.ap-south-2.amazonaws.com

docker build -t spring-boot-devops-app .

docker tag spring-boot-devops-app:latest \
  <your-account-id>.dkr.ecr.ap-south-2.amazonaws.com/spring-boot-devops-app-ecr-repo:latest

docker push \
  <your-account-id>.dkr.ecr.ap-south-2.amazonaws.com/spring-boot-devops-app-ecr-repo:latest

# 3. Get the ALB URL
terraform output alb_dns_name

# 4. Destroy infrastructure after testing (avoids AWS charges)
terraform destroy
```

---

## CI/CD Pipeline

GitHub Actions pipeline triggers automatically on every push to `main` branch:

```
Push to main
     ↓
Checkout code
     ↓
Set up JDK 17
     ↓
Build JAR (mvn package)
     ↓
Configure AWS credentials
     ↓
Login to Amazon ECR
     ↓
Build Docker image → Tag with commit SHA → Push to ECR
     ↓
Force new ECS deployment (zero-downtime rolling update)
```

### GitHub Secrets Required

| Secret | Description |
|--------|-------------|
| AWS_ACCESS_KEY_ID | IAM user access key |
| AWS_SECRET_ACCESS_KEY | IAM user secret key |

---

## AWS Infrastructure (Terraform)

| Resource | Purpose |
|----------|---------|
| VPC (10.0.0.0/16) | Isolated private network |
| 2 Public Subnets | Different AZs for high availability |
| Internet Gateway | Connects VPC to internet |
| Route Table | Routes all traffic to IGW |
| ECR Repository | Stores Docker images (scan on push enabled) |
| IAM Execution Role | Allows ECS to pull image and write logs |
| IAM Task Role | Allows app to access AWS services |
| Application Load Balancer | Distributes traffic across ECS tasks |
| ECS Cluster | Logical grouping of tasks |
| ECS Task Definition | Container blueprint (CPU: 256, Memory: 512) |
| ECS Service | Maintains desired task count, connects to ALB |
| CloudWatch Log Group | Stores container logs (7 day retention) |

---

## Key DevOps Concepts Demonstrated

- **Multi-stage Docker build** — separates build and runtime environments, reduces image size by ~80%
- **Infrastructure as Code** — all AWS resources version-controlled and reproducible via Terraform
- **Remote state management** — Terraform state stored in S3 with locking to prevent corruption
- **Zero-downtime deployment** — ECS rolling update with ALB health checks on /health endpoint
- **Security best practices** — non-root container user, ECR image scanning, least privilege IAM roles
- **CI/CD automation** — every code push automatically builds, packages, and deploys the app

---

## Author

**Vyshnavi**  
AWS Certified Developer – Associate (DVA-C02)
