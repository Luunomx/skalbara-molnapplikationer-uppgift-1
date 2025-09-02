# WordPress Infrastructure on AWS

This project provisions a **scalable and robust WordPress environment** on AWS using **CloudFormation** and **Bash scripts** (IaC).  
The solution is designed for **high availability** and **one-click deployment** of a fully configured WordPress site.

---

## 🏗️ Architecture

The infrastructure consists of:

- **VPC** with 3 Availability Zones (eu-west-1a, eu-west-1b, eu-west-1c).  
- **Application Load Balancer (ALB)** with Listener + Target Group, distributing traffic across EC2 instances.  
- **Auto Scaling Group (ASG)** that automatically creates EC2 instances across 3 AZs using a Launch Template defined in CloudFormation.  
- **EC2 instances** running Apache + PHP + WordPress, bootstrapped with **UserData**.  
- **Amazon Elastic File System (EFS)** mounted at `/var/www/html` on all EC2s, with one Mount Target per AZ (A, B, C).  
- **Amazon RDS (MariaDB)** as the centralized WordPress database.  
- **Security Groups**:  
  - ALB SG → allow HTTP(80) from internet.  
  - EC2 SG → allow HTTP(80) from ALB, SSH(22) from allowed IP.  
  - EFS SG → allow NFS(2049) from EC2 SG.  
  - RDS SG → allow MySQL/MariaDB(3306) from EC2 SG.  
- **Parameters in Bash script** to automatically configure WordPress admin user, password, database and site title at provision time.  
  → Result: WordPress is fully ready on first boot, no manual setup required.  

---

## 🚀 How to Deploy

### 1. Prerequisites
- AWS account with permissions for CloudFormation, EC2, EFS, RDS, ALB.  
- AWS CLI installed and configured (`aws configure`).  
- SSH KeyPair created in AWS EC2 (this project uses `alb-ec2-key`).  

### 2. Create the Infrastructure
Run the following script to **create or update** the CloudFormation stack:

```bash
./create-resources-aws.sh
```

This will:
- Deploy the VPC, ALB, ASG, EFS, and RDS resources.
- Configure EC2 instances with WordPress automatically using UserData.
- Output the **ALB DNS Name**, which you can use to access your WordPress site.

### 3. Access WordPress
After deployment, open the ALB DNS Name in your browser.  
You will get a **ready-to-use WordPress site** with:

- **Admin user:** `admin`  
- **Password:** `Omega181`  
- **Email:** `hugohemlin@hotmail.com`  
- **Site Title:** `Luunoms site`

---

## 🗑️ How to Delete

To remove all resources:

```bash
./delete-resources-aws.sh
```

This will:
- Delete the CloudFormation stack (`luunom-wordpress`).
- Clean up **all AWS resources** created (VPC, ALB, ASG, EC2, EFS, RDS).

---

## 📦 Files

- **`cloudformation-wordpress.yaml`** → CloudFormation template (full infra as code).  
- **`create-resources-aws.sh`** → Bash script to create/update stack with parameters.  
- **`delete-resources-aws.sh`** → Bash script to delete stack and resources.  

---

## 📝 Notes

- Default region: **eu-west-1 (Ireland)**. Update in scripts if needed.  
- SSH is restricted via parameter `AllowedSSH` (set to your IP).  
- **EFS mount** uses `amazon-efs-utils` with TLS → logs at `/var/log/amazon/efs/mount.log`.  
- Solution follows **AWS best practice**: one EFS mount target per AZ.  
- CloudFormation UserData + Bash parameters ensure **idempotent setup** (safe to rerun).  
