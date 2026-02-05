# Multi-Tier Web Application on AWS using Terraform

This project deploys a **3-tier web application architecture** on AWS using Terraform with a focus on **high availability (HA)**, **security**, and **modular design**. It includes a **VPC**, **Application Load Balancer (ALB)**, **EC2 Auto Scaling Group**, and **RDS database**.

---

## 🌐 Architecture Overview

The system is composed of:

1. **VPC & Subnets**
2. **Security Groups**
3. **Application Load Balancer (ALB)**
4. **EC2 Auto Scaling Group**
5. **RDS Database**

![Architecure](diagram/architecture.png)
*Project Architecure.*

---

## 📂 Project Structure

aws-multi-tier-webapp-terraform/
├── modules/
│ ├── vpc/
│ ├── security-groups/
│ ├── alb/
│ ├── ec2-asg/
│ └── rds/
└── environments/
└── dev/
├── main.tf
├── variables.tf
├── terraform.tfvars
└── backend.tf



---

## 🖼 Screenshots

These images demonstrate that the infrastructure is deployed correctly:

### 1️⃣ VPC & Subnets
![VPC and Subnets](screenshots/subnets.png)
*Shows public, private, and DB subnets.*

### 2️⃣ Security Groups
*Inbound/outbound rules for ALB, App, and DB tiers.*

#### 2️⃣.1 Security Group
![Security Groups](screenshots/ec2_security_group.png)
*Inbound/outbound rules for App tier.*
#### 2️⃣.2 Security Group
![Security Groups](screenshots/alb_security_group.png)
*Inbound/outbound rules for ALB tier.*
#### 2️⃣.3 Security Groups
![Security Groups](screenshots/db_security_group.png)
*Inbound/outbound rules for DB tier.*

### 3️⃣ ALB Configuration
![Application Load Balancer](screenshots/application_load_balancer.png)
*Public ALB with listeners and target group.*

### 4️⃣ Target Group & Health Checks
![Target Group Health](screenshots/app_target_group.png)
*All EC2 instances registered and healthy.*

### 5️⃣ EC2 Instances / Auto Scaling
![EC2 Instances](screenshots/ec2_asg.png)
*Shows running instances across multiple AZs.*

### 6️⃣ RDS Database
![RDS Database](screenshots/application_database.png)
*Multi-AZ private database with endpoint.*

### 7️⃣ SSM Session
![SSM Session](screenshots/session_manager.png)
*Connection to EC2 without SSH.*


---

## ⚙️ How to Deploy

1. Initialize Terraform:
    cd aws-multi-tier-webapp-terraform/environments/dev
    `terraform init`
2. Validate configuration:
    `terraform validate`
3. Preview plan:
    `terraform plan`
4. Apply changes:
    `terraform apply`

## 🧪 Testing & Validation
1. Check Terraform outputs

2. Open ALB DNS in browser

3. Verify Target Group health

4. Connect to EC2 via SSM

5. Test Auto Scaling by terminating instance

6. Connect from EC2 to RDS

7. Verify security rules (DB private, SG restrictions)