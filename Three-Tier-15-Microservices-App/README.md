
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
- Creating Target Groups
- Creating Load Balancers
- Updating Application Files
- Creating Auto Scaling Groups
- Accessing the Application
- Creating a CloudFront Distribution
- Customizing WAF and CloudFront
- Testing Auto Scaling

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

- Now SSH to `jump-server-app`.
- Connect to your database by executing:

```bash
mysql -h CHANGE-TO-YOUR-RDS-ENDPOINT -u admin -p
```
- Paste this SQL query to create a **Transactions** table in **webappdb** database:

```sql
CREATE DATABASE webappdb;
SHOW DATABASES;
USE webappdb;
CREATE TABLE IF NOT EXISTS transactions(id INT NOT NULL AUTO_INCREMENT, amount DECIMAL(10,2), description VARCHAR(100), PRIMARY KEY(id));
SHOW TABLES;
INSERT INTO transactions (amount,description) VALUES ('400','groceries');
SELECT * FROM transactions;
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

## 8. Creating Target Groups

In this step, you'll have to create **Target Groups** for both **Web Tier** and **App Tier** so that it can be later used by the **Load Balancer** as a listener.

- Go to **EC2** --> **Target groups**.
- Click on **Create target group**.
- Choose a **Target type** as `Instances`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/28.png?raw=true)

- Enter the following:
    - **Target group name** = `Web-Tier-TG`
    - **Protocol** = `HTTP`
    - **Port** = `80`
    - **VPC** = `3-tier-vpc`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/29.png?raw=true)

- Click **Next**.
- Click **Create target group**.
- Now create the **App Tier Target Group**.
- Choose a **Target type** as `Instances`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/28.png?raw=true)

- Enter the following:
    - **Target group name** = `App-Tier-TG`
    - **Protocol** = `HTTP`
    - **Port** = `4000`
    - **VPC** = `3-tier-vpc`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/30.png?raw=true)

- In **Health checks** choose:
    - **Health check path** = `/health`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/31.png?raw=true)

- In **Advanced health check settings** choose:
    - **Timeout** = `2`
    - **Interval** = `5`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/32.png?raw=true)

- Click **Next**.
- Click **Create target group**.

## 9. Creating Load Balancers

In this step, You'll be creating **Load Balancers** which will be load-balancing the traffic between multiple EC2 instances in your **Auto-Scaling Group**.

- Go to **EC2** --> **Load Balancers**.
- Click on **Create load balancer**.
- In **Load balancer types** select `Application Load Balancer`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/37.png?raw=true)

- Now choose:
    - **Load balancer name** = `app-internal-alb`
    - **Scheme** = `Internal`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/33.png?raw=true)

- In **Network mapping** choose:
    - **VPC** = `3-tier-vpc`
    - **Availability Zones and subnets** = `App-Private-Subnet-1a`, `App-Private-Subnet-1b`, `App-Private-Subnet-1c`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/34.png?raw=true)

- In **Security groups** choose `app-internal-alb-sg`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/35.png?raw=true)

- In **Listeners and routing** choose:
    - **Protocol** = `HTTP`
    - **Port** = `80`
    - **Default action** = `App-Tier-TG`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/36.png?raw=true)

- Click on **Create load balancer**.
- Now create **Web External LB**.
- In **Load balancer types** select `Application Load Balancer`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/37.png?raw=true)

- Now choose:
    - **Load balancer name** = `external-web-alb`
    - **Scheme** = `Internet-facing`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/38.png?raw=true)

- In **Network mapping** choose:
    - **VPC** = `3-tier-vpc`
    - **Availability Zones and subnets** = `Public-Subnet-1a`, `Public-Subnet-1b`, `Public-Subnet-1c`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/39.png?raw=true)

- In **Security groups** choose `web-frontend-alb-sg`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/40.png?raw=true)

- In **Listeners and routing** choose:
    - **Protocol** = `HTTP`
    - **Port** = `80`
    - **Default action** = `Web-Tier-TG`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/41.png?raw=true)

- Click on **Create load balancer**.

## 10. Updaing Application Files

Now you'll have to update the **Application Files** in your cloned repo to get it to work correctly acording to you. Then you'll upload it to your **Application Code** S3 Bucket.

- Open **application-code** --> **nginx.conf** in VS Code.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/42.png?raw=true)

- In **application-code/nginx.conf** update the `Internal-ALB-Address` to the one you just created.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/43.png?raw=true)

- Open **application-code** --> **app.sh** in VS Code.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/44.png?raw=true)

- Update this **Bucket Name** with your `Application Code Bucket` name.
- Now open **application-code** --> **app-tier** --> **DbConfig.js** in VS Code.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/45.png?raw=true)

- Update the following:
    - **AWS Region** = `Your AWS Region`
    - **Secret Name** = `Your RDS Secrets Name`
- Now go to your **Application Code** S3 Bucket.
- Click on **Upload folder**.
- Select the **application-code** folder and upload it.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/46.png?raw=true)

_Wait for the upload to get complete_.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/48.png?raw=true)

## 11. Creating Auto-Scaling Groups

Now you'll create the main component which is **Auto-Scaling Group** for scaling-up and scaling-down your EC2 Instances according to the traffic.

- Go to **EC2** --> **Auto scaling groups**.
- Click on **Create Auto Scaling group**.
- Now select:
    - **Name** = `Web-Tier-ASG`
    - **Launch template** = `Web-Tier-LT`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/49.png?raw=true)

- Now in **Instance type requirements** select:
    - `Manually add instance types`
    - `t2.small`
    - `Family and generation flexible`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/50.png?raw=true)

- Now select:
    - **VPC** = `3-tier-vpc`
    - **Availability Zones and subnets** = `Web-Private-Subnet-1a`, `Web-Private-Subnet-1b`, `Web-Private-Subnet-1c`
    - **Availability Zone distribution** = `Balanced best effort`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/51.png?raw=true)

- Now choose:
    - **Load balancing** = `Attach to an existing load balancer`
    - **Attach to an existing load balancer** = `Choose from your load balancer target groups`
    - **Existing load balancer target groups** = `Web-Tier-TG | HTTP`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/52.png?raw=true)

- In the **Scaling** section, choose:
    - **Automatic Scaling** = `Target tracking scaling policy`
    - **Target value** = `60`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/53.png?raw=true)

- In **SNS Topic** choose `web-tier-sns`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/Web-SNS.png?raw=true)

- Add a **tag**:
    - **Key** = `Name`
    - **Value** = `Web-ASG`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/54.png?raw=true)

- Click **Next**
- Click **Create Auto Scaling group***.
- Now create the **App Tier** Auto-Scaling Group.
- Now select:
    - **Name** = `App-Tier-ASG`
    - **Launch template** = `App-Tier-LT`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/55.png?raw=true)

- Now in **Instance type requirements** select:
    - `Manually add instance types`
    - `t2.small`
    - `Family and generation flexible`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/56.png?raw=true)

- Now select:
    - **VPC** = `3-tier-vpc`
    - **Availability Zones and subnets** = `App-Private-Subnet-1a`, `App-Private-Subnet-1b`, `App-Private-Subnet-1c`
    - **Availability Zone distribution** = `Balanced best effort`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/57.png?raw=true)

- Now choose:
    - **Load balancing** = `Attach to an existing load balancer`
    - **Attach to an existing load balancer** = `Choose from your load balancer target groups`
    - **Existing load balancer target groups** = `App-Tier-TG | HTTP`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/58.png?raw=true)

- In the **Scaling** section, choose:
    - **Automatic Scaling** = `Target tracking scaling policy`
    - **Target value** = `60`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/59.png?raw=true)

- In **SNS Topic** choose `app-tier-sns`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/60.png?raw=true)

- Add a **tag**:
    - **Key** = `Name`
    - **Value** = `App-ASG`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/61.png?raw=true)

- Click **Next**
- Click **Create Auto Scaling group***.
_Now it will create two new EC2 instances_.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/62.png?raw=true)

## 12. Accessing the Application

Now you can access your **Application** with your **External Load Balancer DNS**.

- Go to **external-web-alb**.
- Copy this **DNS**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/63.png?raw=true)

- Paste it in your **web browser**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/68.png?raw=true)

- Now add some data in the database.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/67.png?raw=true)

- You'll see it also in your Database internally.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/69.png?raw=true)

## 13. Creating a CloudFront Distribution

Now you'll have to create a **CloudFront Distribution** for a better latency and access to your application.

- Go to **CloudFront**.
- Click on **Create distribution**.
- Enter the following:
    - **Distribution name** = `three-tier-aws`
    - **Description** = `A CloudFront Distribution for Three Tier App`.
    - **Distribution type** = `Single website or app`
    - **Custom domain** = `Add if you have one otherwise leave it blank`
    - **Tag**
        - `Name` = `three-tier-aws`
- Click **Next**.
- In **Specify origin** select:
    - **Origin type** = `Elastic Load Balancer`
    - **Elastic Load Balancing origin** = `external-web-alb`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/71.png?raw=true)

- In **Customize origin settings** choose:
    - **Enable Origin Shield** = `No`
    - **Protocol** = `HTTP only`
    - **HTTP port** = `80`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/72.png?raw=true)

- In **Web Application Firewall (WAF)** select `Enable security protections`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/73.png?raw=true)

- Click **Next**.
- Click **Create distribution**.
- Now copy this **DNS**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/74.png?raw=true)

- Paste it into your web browser.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/75.png?raw=true)

_Welldone! You are now accessing your application with CloudFront + AWS WAF for Website Security_

## 14. Customizing WAF and CloudFront

Now this is the epic and fun part where you'll be customizing **Web ACL rules** for any incoming traffic to your application.

- Go to your **three-tier-aws** distribuiton.
- Go to **Security** tab.
- Click **Manage protections**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/76.png?raw=true)

- Check-Mark **Rate limiting**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/77.png?raw=true)

- Click **Save changes**.
- In **CloudFront geographic restrictions** add `[Your Country]` to **Block list**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/78.png?raw=true)

- Click **Save changes**.
- Now you'll get a **403 error** from **CloudFront**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/79.png?raw=true)

- Now go to **WAF & Shield**.
- Click **Create web ACL**.
- Select **Global resources**.
- Enter **Name** = `Three-Tier-WAF`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/80.png?raw=true)

- Click on **Add AWS resources** and add your **CloudFront distribution**.
- Click **Next**.
- Select **Add my own rules and rule groups**.
- In **Rule type** select `Rule builder`.
- Enter **Name** = `Block[MyCountry]WithCustomResponse`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/81.png?raw=true)

- Now select:
    - **If a request** = `matches the statement`
    - **Inspect** = `Originates from a country in`
    - **Country codes** = `[Your Country Code]`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/82.png?raw=true)

- In **Action** choose `Block`.
- In **Custom response** select:
    - **Response code** = `404`
    - **Choose how you would like to specify the response body** = `Create a custom reponse body`
    - **Response body object name** = `Block[MyCountry]WithCustomResponse`
    - **Content type** = `HTML`
- Paste this in **Response body**:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Oops! 🇵🇰 Not Today, Pakistan</title>
  <style>
    body {
      font-family: 'Comic Sans MS', cursive, sans-serif;
      background-color: #fefefe;
      color: #333;
      text-align: center;
      padding: 50px;
    }
    img {
      max-width: 200px;
      margin-top: 20px;
    }
    .container {
      max-width: 600px;
      margin: auto;
    }
    h1 {
      font-size: 3em;
      color: #ff0000;
    }
    p {
      font-size: 1.3em;
      margin-top: 20px;
    }
    .tiny {
      font-size: 0.8em;
      color: gray;
      margin-top: 30px;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>🛑 Access Denied!</h1>
    <p>Sorry Pakistan,</p>
    <p>Even though we love your biryani, cricket passion, and memes — our website has decided to take a little vacation from your region. 🌴😎</p>
    <img src="https://media.giphy.com/media/3o7abKhOpu0NwenH3O/giphy.gif" alt="No Access">
    <p>Try accessing us from a different location (or maybe teleport?)</p>
    <p>We’ll miss you... maybe. 😅</p>
    <div class="tiny">
      <p>If you think this is a mistake, send us a pigeon 🐦 or maybe an email — whatever works.</p>
    </div>
  </div>
</body>
</html>
```

- Click **Add rule**.
- Select `Block[MyCountry]WithCustomResponse`.
- Click **Create web ACL**.
- Now access it again with your **CloudFront DNS**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/86.png?raw=true)

## 15. Testing Auto Scaling

Now finally, you have to test the **Auto-Scaling** of your application to handle the traffic load.

- Go to both of your **ASGs**.
- Update the **capacity** as:

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/87.png?raw=true)

_Now your ASG will create 2 new EC2 instances_

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-15-Microservices-App/Images/88.png?raw=true)


_Congratulations to you on successfully building this entire project from end-to-end and achieving scalability, fault tolerance, high-availability and security._




