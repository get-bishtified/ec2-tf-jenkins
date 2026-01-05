# Terraform EC2 + Jenkins CI/CD

This repository has been converted to provide an example Terraform configuration to provision an EC2 instance and a Jenkins pipeline that performs Terraform operations (init, plan, apply) on the Jenkins controller (master).

---

## What you'll get ✅
- `terraform/` — Terraform configuration that creates an EC2 instance with a security group and outputs such as public IP.
- `Jenkinsfile` — Declarative Jenkins pipeline that runs on the **Jenkins master** and executes Terraform commands using AWS credentials stored in Jenkins.

---

## Requirements
- A Jenkins server (controller) with the ability to run shell (`sh`) commands and with Terraform installed.
- An AWS account and an IAM user with permissions to create EC2 and security groups. Prefer an IAM user with least privilege.
- A Jenkins credential for AWS, stored as **Username with password** (`credentialsId`: `aws-creds`) where username = `AWS_ACCESS_KEY_ID` and password = `AWS_SECRET_ACCESS_KEY`.

---

## Terraform structure
- `terraform/main.tf` — resources (aws_instance, aws_security_group)
- `terraform/variables.tf` — variables for `aws_region`, `ami`, `instance_type`, `key_name`.
- `terraform/outputs.tf` — instance outputs (public IP, DNS, instance ID).

> Note: For production use, configure a remote backend (S3 + DynamoDB) for state locking.

---

## Usage (Locally)
1. Install Terraform (v1.3+ recommended).
2. Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` and update variables (AMI, key_name, region, instance_type).
3. Run:

```bash
cd terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

---

## Usage with Jenkins pipeline
1. In Jenkins, create a Pipeline job (Multibranch Pipeline or Pipeline from SCM) pointing to this repo.
2. Add a Jenkins credential (`aws-creds`) of type **Username with password** (username = AWS key, password = AWS secret).
3. Run the pipeline. By default it will:
   - `terraform init` and `terraform plan` (artifacts stored)
   - pause for manual approval (unless `AUTO_APPROVE=true` parameter is passed)
   - apply the plan and archive outputs


---

## Security & Notes ⚠️
- Running Terraform on the Jenkins controller (master) and having the controller manage infrastructure is a deliberate choice with security implications — consider using a dedicated, isolated agent instead.
- Use an AWS IAM user with the minimum required privileges, and prefer remote state backends with locking.

---

## 🎥 Learn With YouTube Tutorials

Each project is **explained step-by-step** on YouTube with visuals and walkthroughs:

🔗 [📺 Bishtify - Build Skills, Not Just Resumes](https://www.youtube.com/@getbishtified) 
🧠 Subscribe for weekly ML + CloudOps demos.

---

📩 **Contact:**  
📧 `support@bishtify.com`

🤝 Connect With Me - 📧 [Click here](https://topmate.io/pradeep_singh_bisht)
🔗 Get Bishtified with:
Bishtify - Let’s build skills — not just resumes! 🚀
