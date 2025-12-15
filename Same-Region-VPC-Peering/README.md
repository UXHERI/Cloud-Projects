
# Same Region VPC Peering

In this **AWS Networking** project, I'll be showing you how you can make a **VPC Peering** connection inside the same region.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/Infra.png?raw=true)

This project will guide you with hands-on experience of _how you can make a **VPC Peering** connection in the same **AWS Region**._


## Step-by-Step Project Guide

- Create VPC-1A
- Create VPC-1B
- Launch EC2 in VPC-1A
- Launch EC2 in VPC-1B
- Checking ping connection
- Create a VPC Peering connection
- Configure Route Tables

## 1. Create VPC-1A

In this first step, I'll be creating a **VPC** in **US-EAST-1A** AZ in **US-EAST-1** region.

- Go to **AWS Management Console** → **VPC** → **Your VPCs**.
- Click **Create VPC**.
- Select **VPC and more**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/0.png?raw=true)

- Name it `VPC-1a`.
- Enter the **IPv4 CIDR block** as `10.75.0.0/16`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/1.png?raw=true)

- Select **Number of Availability Zones (AZs)** as `1` and select `us-east-1a`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/2.png?raw=true)

- Select both **Number of public subnets** and **Number of private subnets** as `1`.
- For **Public Subnet CIDR block** enter `10.75.1.0/24`.
- For **Private Subnet CIDR block** enter `10.75.2.0/24`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/3.png?raw=true)

- In the **NAT Gateway** select `Zonal` and `In 1 AZ`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/4.png?raw=true)

- Click **Create VPC**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/5.png?raw=true)

_It will take some time to create the **VPC**._

- Select this **VPC** and go to its **Security Group**.
- Add these **Inbound Rules**:
    - **Type** = `SSH`
    - **Source** = `0.0.0.0/0`
    - **Type** = `ICMP`
    - **Source** = `0.0.0.0/0`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/6.png?raw=true)

## 2. Create VPC-1B

In the second step, I'll be creating a **VPC** in **US-EAST-1B** AZ in **US-EAST-1** region.

- Go to **AWS Management Console** → **VPC** → **Your VPCs**.
- Click **Create VPC**.
- Select **VPC and more**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/7.png?raw=true)

- Name it `VPC-1b`.
- Enter the **IPv4 CIDR block** as `192.168.0.0/16`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/8.png?raw=true)

- Select **Number of Availability Zones (AZs)** as `1` and select `us-east-1b`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/9.png?raw=true)

- Select both **Number of public subnets** and **Number of private subnets** as `1`.
- For **Public Subnet CIDR block** enter `192.168.1.0/24`.
- For **Private Subnet CIDR block** enter `192.168.2.0/24`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/10.png?raw=true)

- In the **NAT Gateway** select `Zonal` and `In 1 AZ`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/11.png?raw=true)

- Click **Create VPC**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/5.png?raw=true)

_It will take some time to create the **VPC**._

- Select this **VPC** and go to its **Security Group**.
- Add these **Inbound Rules**:
    - **Type** = `SSH`
    - **Source** = `0.0.0.0/0`
    - **Type** = `ICMP`
    - **Source** = `0.0.0.0/0`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/12.png?raw=true)

## 3. Launch EC2 in VPC-1A
Now that we have created the required two VPCs, its time to launch instances in **VPC-1A**.

- Go to **AWS Management Console** → **EC2**.
- Click **Launch instance**.
- Name it `Jump-Server-1a`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/13.png?raw=true)

- Select **Amazon Linux 2023** AMI.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/14.png?raw=true)

- In the **Instance type** select `t2.micro`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/15.png?raw=true)

- Create a **key-pair** of name `VPC-Peering`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/16.png?raw=true)

- In the **Network settings** configure:
    - **VPC** = `VPC-1a`
    - **Subnet** = `Public-Subnet-1a`
    - **Auto-assign public IP** = `Enable`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/17.png?raw=true)

- In the **Security group** select this `default` security group.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/18.png?raw=true)

- Click **Launch instance**.

- Now click again on **Launch instance** to launch a private instance.
- Name it `Private-EC2-1a`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/19.png?raw=true)

- Select **Amazon Linux 2023** AMI.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/20.png?raw=true)

- In the **Instance type** select `t2.micro`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/21.png?raw=true)

- Select the `VPC-Peering` **key-pair**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/22.png?raw=true)

- In the **Network settings** configure:
    - **VPC** = `VPC-1a`
    - **Subnet** = `Private-Subnet-1a`
    - **Auto-assign public IP** = `Disable`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/23.png?raw=true)

- In the **Security group** select this `default` security group.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/24.png?raw=true)

- Click **Launch instance**.

## 4. Launch EC2 in VPC-1B

Now that we have launched instances in **VPC-1A**, let's launch instances in **VPC-1B**.

- Go to **AWS Management Console** → **EC2**.
- Click **Launch instance**.
- Name it `Private-EC2-1b`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/25.png?raw=true)

- Select **Amazon Linux 2023** AMI.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/26.png?raw=true)

- In the **Instance type** select `t2.micro`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/27.png?raw=true)

- Select the `VPC-Peering` **key-pair**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/28.png?raw=true)

- In the **Network settings** configure:
    - **VPC** = `VPC-1b`
    - **Subnet** = `Private-Subnet-1b`
    - **Auto-assign public IP** = `Disable`

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/29.png?raw=true)

- In the **Security group** select this `default` security group.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/30.png?raw=true)

- Click **Launch instance**.

## 5. Checking ping connection

Now let's check if these **EC2** instances can ping each other or not.

- First we'll ping **Private-EC2-1a** from **Jump-Server-1a**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/31.png?raw=true)

- Now ping **Private-EC2-1b** from **Jump-Server-1a**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/33.png?raw=true)

_As we can see it can't ping the **private** EC2 instance in the other subnet, so now we'll build a **peering connection** between them._

## 6. Create a VPC Peering connection

Now we have to establish a **peering connection** between these two **VPCs**.

- Go to **AWS Management Console** → **VPC** → **Peering connections**.
- Click **Create peering connection**.
- Name it `VPC-1A-To-1B`.
- Enter the **Requester VPC** as `10.75.0.0/16`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/34.png?raw=true)

- Enter the **Accepter VPC** as `192.168.0.0/16`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/35.png?raw=true)

- Select this peering connection, click on **Actions** and the click on **Accept request**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/36.png?raw=true)

## 7. Configure Route Tables

Now lastly, we have to modify the **Route Tables** to finally route the traffic from **VPC-1A** to **VPC-1B**.

- Click on **Modify my route tables now**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/37.png?raw=true)

- Select **VPC-1A**'s Private Route Table and click on **Edit routes**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/38.png?raw=true)

- Add the route to **VPC-1B** and select the **peering connection**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/39.png?raw=true)

- Now add a route to **VPC-1A** in **VPC-1B** private route table and select the **peering connection**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/40.png?raw=true)

- Now test that ping connection again.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Same-Region-VPC-Peering/Images/41.png?raw=true)

_Now the ping connection is successfull which indicates that the **VPC Peering** connection is successfully built between these two VPCs and now they can communicate privately with each other._ 
