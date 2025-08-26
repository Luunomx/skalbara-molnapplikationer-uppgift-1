# WordPress Infrastructure on AWS

This project provisions a **scalable and robust WordPress environment** on AWS using **CloudFormation** and **Bash scripts**.  
The environment is based on the following components:

- **VPC** with 2 Availability Zones  
- **Application Load Balancer (ALB)**  
- **Auto Scaling Group (ASG)** with EC2 instances  
- **Amazon Elastic File System (EFS)** for shared WordPress files  
- **Amazon RDS (MariaDB)** for the WordPress database  
- **Security Groups** for controlled access  
- **User Data bootstrap** that installs and configures WordPress automatically  

---

## 🚀 How to Deploy

### 1. Prerequisites
- An AWS account with IAM permissions for CloudFormation, EC2, EFS, RDS, and ALB.  
- AWS CLI installed and configured (`aws configure`).  
- A KeyPair created in AWS EC2 (this project uses `alb-ec2-key`).  

### 2. Create the Infrastructure
Run the following script to **create or update** the CloudFormation stack:

```bash
./create-resources-aws.sh
```

This will:
- Create the VPC, ALB, ASG, EFS, and RDS resources.
- Bootstrap EC2 instances with WordPress.
- Output the **ALB DNS Name**, which you can use to access your WordPress site.

### 3. Access WordPress
Once the stack is created, copy the ALB DNS Name from the script output and open it in your browser.  
You should see your WordPress site automatically installed and configured with:

- **Admin user:** `admin`  
- **Password:** `Omega181`  
- **Email:** `hugohemlin@hotmail.com`  
- **Site Title:** `Luunoms site`

---

## 🗑️ How to Delete

To remove all resources created by the stack:

```bash
./delete-resources-aws.sh
```

This will:
- Delete the CloudFormation stack (`wordpress-stack`).
- Clean up **all AWS resources** created by the template (VPC, ALB, ASG, EC2, EFS, RDS).

---

## 📦 Files

- **`cloudformation-wordpress.yaml`** → CloudFormation template describing the full WordPress infrastructure.  
- **`create-resources-aws.sh`** → Bash script to create or update the CloudFormation stack.  
- **`delete-resources-aws.sh`** → Bash script to delete the CloudFormation stack and all associated resources.  

---

## 📝 Notes

- Default region is set to **eu-west-1 (Ireland)**. Update the region in the scripts if needed.  
- The stack name is `wordpress-stack` (can be changed inside the scripts).  
- SSH is allowed from all IPs by default (`0.0.0.0/0`). For better security, restrict it to your own IP in the script.  
