
# Three Tier 15 Microservices Application

In this project I will be showing you step-by-step how I built and deployed a three tier application which had 15 microservices on AWS EC2 with Multi-AZ RDS instances.

![Project Diagram](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/Three-Tier-15-Microservices-App/Images/Project-Diagram.png)

This project is by **Harish Shetty** and it has a lot of AWS services used as you can see in the project diagram. There are EC2 instances in an Auto-Scaling Group which has the **Application Code** and the **RDS Database** also has two instances for **High-Availability** with its credentials stored in a **Secrets Manager**.

## Step-by-Step Project Guide:

- Deploying the infrastructure
- Configuring the Jump Servers
- Createing Jump Servers AMIs
- Creating a CloudTrail
- Cloning the Application Repository
- Creating the RDS 
- Creating Launch Templates

## 1. Deploying the infrastructure

First of all, its infrastructure is mainly deployed and provisioned with **Terraform** by deploying its main services like **VPC**, **Security Groups**, **EC2 Instances**, **S3 Buckets**, **RDS Secrets**, **IAM Roles**, and **SNS Notifications**.

- Download these terraform files from [here](https://github.com/UXHERI/Cloud-Projects/tree/main/Three-Tier-15-Microservices-App/Terraform).
- Run `ssh-keygen` and name it `3-tier-app` to make an **EC2 Key-Pair**.
- In this first step, don't include the `secrets.tf` file as we don't have the **RDS Endpoint** yet.
- Update the `variables.tf` file according to you.
- Execute these commands to deploy the infrastructure:

```powershell
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```
_This will take some time to deploy the infrastructure._

## 2. Configuring the Jump Servers

Now you have to configure the **Jump Servers** which will then be used for deploying your application automatically in an **Auto-Scaling Group**.
- SSH into `jump-server-web`.
- Run these commands to install **nginx** and **git**:

```bash
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo service nginx restart
sudo chkconfig nginx on
sudo yum install git -y
```

- Run these commands to install **AWS CLI**:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

- Now run `aws configure` to configure your **Access Keys** and **Secret Access Keys**.
- Run these commands to install **Node JS**:

```bash
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v # Should print "v22.19.0".
nvm current # Should print "v22.19.0".

# Verify npm version:
npm -v # Should print "10.9.3".
```

- Now SSH into `jump-server-app`.
- Run these commands to install **MySQL Client**:

```bash
sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
sudo dnf install mysql-community-client -y
mysql --version
```

- Run these commands to install **AWS CLI**:

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

- Now run `aws configure` to configure your **Access Keys** and **Secret Access Keys**.

- Run these commands to install **Node JS**:

```bash
# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 22
npm install -g pm2

# Verify the Node.js version:
node -v # Should print "v22.19.0".
nvm current # Should print "v22.19.0".

# Verify npm version:
npm -v # Should print "10.9.3".
```

## 3. Creating Jump Servers AMIs

Now you'll have to create **Amazon Machine Images (AMIs)** of the configured **Jump Servers** so that it'll be later used to create **Launch Templates**.

- Go to **EC2** --> **Instances**.
- Select `jump-server-web`.
- Go to **Actions** --> **Image and templates** --> **Create image**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/1.png?raw=true)

- Enter **Image name** = `Web-AMI`.
- Enter **Image description** = `An AMI for Web Tier`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/2.png?raw=true)

- Click **Create image**.
- Now select `jump-server-app`.
- Go to **Actions** --> **Image and templates** --> **Create image**.
- Enter **Image name** = `App-AMI`.
- Enter **Image description** = `An AMI for App Tier`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/3.png?raw=true)

_Now check both of the AMIs_.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/4.png?raw=true)

## 4. Creating a CloudTrail

Now you'll have to create a **CloudTrail** to track your **AWS Account Activity** and dumping it to an **S3 Bucket**.

- Go to **CloudTrail**.
- Click on **Create a trail**.
- Enter **Trail name** = `AWS-Account-Activity-3-Tier`.
- Click **Create trail**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/5.png?raw=true)

_Now your **CloudTrail** and an **S3 Bucket** for it will be created_.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/6.png?raw=true)

## 5. Cloning the Application Repository

Now you'll have to clone the **Aplication Repository** on your **local computer**.

- Run this command to clone it:

```powershell
git clone https://github.com/harishnshetty/3-tier-aws-15-services.git
```

## 6. Creating the RDS Database

In this step, you will create an **RDS Database** with **Multi-AZ** deployment for **High-Availability** and **Fault Tolerance**.

- Go to **Aurora and RDS**.
- Go to **Subnet groups**.
- Click on **Create DB subnet group**.
- Enter the following:
    - **Name** = `three-tier-rds-subnetgroup`
    - **Description** = `A Subnet Group for RDS Database`
    - **VPC** = `3-tier-vpc`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/8.png?raw=true)

- Now select:
    - **Availability Zones** = `us-east-1a`, `us-east-1b`, `us-east-1c`
    - **Subnets** = `DB-Private-Subnet-1a`, `DB-Private-Subnet-1b`, `DB-Private-Subnet-1c`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/9.png?raw=true)

-  Click **Create**.
- Now go to **Databases**.
- Click on **Create database**.
- Choose the following:
    - **Choose a database creation method** = `Standard create`
    - **Engine type** = `MySQL`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/10.png?raw=true)

- Now choose:
    - **Templates** = `Dev/Test`
    - **Deployment options** = `Multi-AZ DB instance deployment (2 instances)`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/11.png?raw=true)

- Now Enter:
    - **DB instance identifier** = `db-3-tier`
    - **Master username** = `admin`
    - **Credentails Management** = `Self managed`
    - **Master password** = `[Your RDS DB Password]`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/12.png?raw=true)

- In **Instance configuration** choose:
    - `Burstable classes (includes t classes)`
    - `db.t3.small`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/13.png?raw=true)

- In **Storage** choose:
    - **Storage type** = `General Purpose SSD (gp2)`
    - **Allocated storage** = `20`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/14.png?raw=true)

- In **Connectivity** choose:
    - **Virtual Private Cloud (VPC)** = `3-tier-vpc`
    - **DB subnet group** = `three-tier-rds-subnetgroup`
    - **Public access** = `No`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/15.png?raw=true)

- Now choose **VPC security group (firewall)** = `db-srv-sg`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/16.png?raw=true)

- In **Monitoring** uncheck the **Enable Enhanced monitoring**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/17.png?raw=true)

- Click **Create database**.
- Now update the `variables.tf` file with your RDS Endpoint which you can get from here:

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/RDS-Endpoint.png?raw=true)

- Now **Download/Copy** the `secrets.tf` file from [here](https://github.com/UXHERI/Cloud-Projects/tree/main/Three-Tier-15-Microservices-App/Terraform).
- Apply it by executing:

```powershell
terraform validate
terraform plan
terraform apply -auto-approve
```

## 7. Creating Launch Templates

Now you'll have to create the **Launch Templates** from the **AMIs** you have created before.

- Go to **EC2** --> **Launch Templates**.
- Click on **Create launch template**.
- Enter the following:
    - **Launch template name** = `Web-Tier-LT`
    - **Template version description** = `A Launch Template for Web Tier`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/18.png?raw=true)

- In the **AMI** section, choose `Web-AMI`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/19.png?raw=true)

- In **Security groups** choose `web-srv-sg`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/20.png?raw=true)

- In the **IAM instance profile** choose `3-tier-web-profile`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/21.png?raw=true)

- In the **User data** write:

```bash
#!/bin/bash
# Log everything to /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Install AWS CLI v2 (if not already)
yum install -y awscli

# Download application code from S3
aws s3 cp s3://<YOUR-S3-BUCKET-NAME>/application-code /home/ec2-user/application-code --recursive

# Go to app directory
cd /home/ec2-user/application-code

# Make script executable and run it
chmod +x web.sh
sudo ./web.sh
```

> [!IMPORTANT]
> Update the [YOUR-S3-BUCKET-NAME] with your actual S3 Bucket name for the Application Code.

- Click **Create launch Template**.
- Now create another **Launch Template** by clicking again on **Create launch template**.
- Enter the following:
    - **Launch template name** = `App-Tier-LT`
    - **Template version description** = `A Launch Template for App Tier`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/23.png?raw=true)

- In the **AMI** section, choose `App-AMI`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/24.png?raw=true)

- In **Security groups** choose `app-srv-sg`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/25.png?raw=true)

- In the **IAM instance profile** choose `3-tier-app-profile`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/26.png?raw=true)

- In the **User data** write:

```bash
#!/bin/bash
# Log everything to /var/log/user-data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Install AWS CLI v2 (if not already)
yum install -y awscli

# Download application code from S3
aws s3 cp s3://<YOUR-S3-BUCKET-NAME>/application-code /home/ec2-user/application-code --recursive

# Go to app directory
cd /home/ec2-user/application-code

# Make script executable and run it
chmod +x app.sh
sudo ./app.sh
```

> [!IMPORTANT]
> Update the [YOUR-S3-BUCKET-NAME] with your actual S3 Bucket name for the Application Code.
- Click **Create launch template**.








