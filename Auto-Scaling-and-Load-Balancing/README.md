
# Scaling and Load Balancing with AWS

In this project, I am going to show you how you can use the **Elastic Load Balancing (ELB)** and Amazon EC2 **Auto Scaling** to load balance and automatically scale your infrastructure.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/FinalArchitecture.png?raw=true)


## Step-by-Step Project Guide:

- Set Up your Architecture.
- Create an AMI from EC2 instance.
- Create a load balancer.
- Create a launch template and an Auto Scaling group.
- Use Amazon CloudWatch alarms to monitor the performance of your infrastructure.

## 1. Set Up your Architecture

In this section, we will set up our architecture for this project like creaing a VPC, an EC2 instance with an Apache website running on it.

## ☁️ Create Your VPC

- Head to your **AWS console** - search for `VPC` at the search bar at top of your page.
- From the left hand navigation bar, select **Your VPCs**.
- Select **Create VPC**.
- In **Resources to create**, select **VPC only**.
- In the **Name tag**, select `Lab VPC`.
- In the **IPv4 CIDR**, write `10.0.0.0/16`.
- For **IPv6 CIDR block**, select **No IPv6 CIDR block**.
- Keep the **Tenancy** to **Default**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS1.png?raw=true)

- Select **Create VPC**.
- From the left hand navigation bar, select **Subnets**.
- Click **Create subnet**.
- In the **VPC ID** select **Lab VPC**.
- In the **Subnet name**, enter `Public subnet A`.
- In the **Availability Zone**, select the **First Availability Zone** (i.e `us-east-1a`).
- In the **IPv4 subnet CIDR block**, enter `10.0.0.0/24`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS2.png?raw=true)

- Click on **Add new subnet**.
- In the **Subnet name**, enter `Public subnet B`.
- In the **Availability Zone**, select the **Second Availability Zone** (i.e `us-east-1b`).
- In the **IPv4 subnet CIDR block**, enter `10.0.1.0/24`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS3.png?raw=true)

- Click on **Add new subnet**.
- In the **Subnet name**, enter `Private subnet A`.
- In the **Availability Zone**, select the **First Availability Zone** (i.e `us-east-1a`).
- In the **IPv4 subnet CIDR block**, enter `10.0.2.0/24`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS4.png?raw=true)

- Click on **Add new subnet**.
- In the **Subnet name**, enter `Private subnet B`.
- In the **Availability Zone**, select the **Second Availability Zone** (i.e `us-east-1b`).
- In the **IPv4 subnet CIDR block**, enter `10.0.3.0/24`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS5.png?raw=true)

- Click **Create subnet**.
_Your Subnets are now created!_

![App SCreenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS6.png?raw=true)

- From the left hand navigation bar, select **Internet gateways**.
- Click on **Create internet gateway**.
- In the **Name tag**, enter `Lab-IGW`.
- On the **Lab-IGW** page, click **Actions** and click **Attach to VPC**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS7.png?raw=true)

- In the **Available VPCs**, select **Lab VPC**.
- Click **Attach internet gateway**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS8.png?raw=true)

- From the left hand navigation bar, select **Route tables**.
- Click on **Create route table**.
- In the **Name** option, select `Public Route Table`.
- In the **VPC** option, select **Lab VPC**.
- Click **Create route table**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS9.png?raw=true)

- Click on **Create route table** again.
- In the **Name** option, select `Private Route Table`.
- In the **VPC** option, select **Lab VPC**.
- Click **Create route table**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS10.png?raw=true)

- Select **Public Route Table**.
- In the **Subnet associations**, click on **Edit subnet associations**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS11.png?raw=true)

- Add **Public subnet A** and **Public subnet B**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS13.png?raw=true)

- Select **Private Route Table**.
- In the **Subnet associations**, click on **Edit subnet associations**.

![App SCreenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS12.png?raw=true)

- Add **Private subnet A** and **Private subnet B**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS14.png?raw=true)

- Select **Public Route Table**.
- In **Routes**, click on **Edit routes**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS15.png?raw=true)

- Click on **Add route**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS16.png?raw=true)

- In the **Destination** add `0.0.0.0/0`, and in **Target** add `Lab-IGW`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS17.png?raw=true)

- Now your **Public subnets** should have a route to the **Internet** via **Internet Gateway**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS18.png?raw=true)

- Review the **Resource map** of your VPC.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS19.png?raw=true)

_Now your VPC is successfully created!_

## Create a Web Security Group

Now we have to create a security group for accessing the web server and SSH into our instance.

- In the **VPC** console, under the **Security** section, choose **Security groups**.
- Click **Create security group**.
- In the **Security group name**, enter `Web Security Group`.
- In the **Description**, enter `Allows access to web server`.
- For **VPC**, choose **Lab VPC**.
- For the **Inbound Rules** add:
    - **SSH** on **Port:22**, from **Anywhere-IPv4:** `0.0.0.0/0`.
    - **HTTP** on **Port:80**, from **Anywhere-IPv4:** `0.0.0.0/0`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS21.png?raw=true)

- Click **Create security group**.

_You have successfully created a Security Group for your instance!_

## 💻 Launch an instance in your VPC

In this step, we will create an EC2 instance with our web server on that.

- Head to the **AWS console** - search for `EC2` in the search bar at the top of screen.
- Select **Instances** at the left hand navigation bar.
- Select **Launch instances**.
- Name your EC2 instance `Web Server`.
- For the **Amazon Machine Image**, select **Amazon Linux 2023 AMI**.
- For the **Instance type**, select **t3.micro**.
- For the **Key pair (login)** panel, select **Proceed without a key pair (not recommended)**.
- At the **Network settings** panel, select **Edit** at the right hand corner.
- Under **VPC**, select `Lab VPC`.
- Under **Subnet**, select your VPC's **Public Subnet B**.
- Keep the **Auto-assign public IP** setting to **Enable**.
- For the **Firewall (security groups)** setting, choose **Web Security Group**.
- In the **Advanced details** for **User data - optional** paste the following code:

```bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
```

- Click **Launch instance**.

_You have successfully created an EC2 instance and configured Apache Web Server on it!_

## 2. Create an AMI from EC2 Instance

- On the **AWS Console**, in the Search bar, enter and choose `EC2` to open the **Amazon EC2 Management Console**.
- In the left navigation pane, choose **Instances**.
- Select the **Web Server 1**.
- Click on **Actions**, then click on **Image and templates** and choose **Create image**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/1.png?raw=true)

- For **Image name**, enter `Web Server AMI`.
- For **Image description - optional**, enter `Lab AMI for Web Server`.
- Enable the **Reboot instance**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/2.png?raw=true)

- Choose **Create image**.

## 3. Create a Load Balancer

- In the left navigation pane, locate the **Load Balancing** section, and choose **Load Balancers**.
- Choose **Create load balancer**.
- In the **Load balancer types** section, for **Application Load Balancer**, choose **Create**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/SS20.png?raw=true)

- For the **Load balancer name**, enter `LabELB`.

![App SCreenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/4.png?raw=true)

- In the **Network mapping** section, configure the following options:
    - For **VPC**, choose **Lab VPC**.
    - For **Mappings**, choose both Availability Zones listed.
    - For the first Availability Zone, choose **Public Subnet 1**.
    - For the second Availability Zone, choose **Public Subnet 2**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/5.png?raw=true)

- In the **Security groups** section, choose **Web Security Group**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/6.png?raw=true)

- In the **Listeners and routing** section, choose the **Create target group** link.
- On the new **Target groups** browser tab, in the **Basic configuration** section, configure the following:
    - For **Choose a target type**, choose **Instances**.
    - For **Target group name**, enter `lab-target-group`.
- At the bottom of the page, choose **Next**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/7.png?raw=true)

- On the **Register targets** page, choose **Create target group**.
- Return to the **Load balancers** browser tab. In the **Listeners and routing** section, choose **lab-target-group**.

![App SCreenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/8.png?raw=true)

- At the bottom of the page, choose **Create load balancer**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/9.png?raw=true)

## 4. Create a Launch Template and an Auto Scaling Group

In this step, I am going to show you how you can create a **Launch Template** from the AMI we have created earlier, which will be use to launch EC2 instances based on-demand in an **Auto-Scaling group**. And we'll create that Auto-Scaling group too.

## Create a Launch Template
- In the left navigation pane, locate the **Instances** section, and choose **Launch Templates**.
- Choose **Create launch template**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/10.png?raw=true)

- On the **Create launch template** page, in the **Launch template name and description** section, configure the following options:
    - For **Launch template name - required**, enter `lab-app-launch-template`.
    - For **Template version description**, enter `A web server for the load test app`.
    - For **Auto Scaling guidance**, enable **Provide guidance to help me set up a template that I can use with EC2 Auto Scaling**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/11.png?raw=true)

- In the **Application and OS Images (Amazon Machine Image) - required** section, choose the **My AMIs** tab. Notice that **Web Server AMI** is already chosen.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/12.png?raw=true)

- In the **Instance type** section, choose the **Instance type** dropdown list, and choose **t3.micro**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/13.png?raw=true)

- In the **Key pair (login)** section, confirm that the **Key pair name** dropdown list is set to **Don't include in launch template**.
- In the **Network settings** section, choose the **Security groups** dropdown list, and choose **Web Security Group**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/14.png?raw=true)

- Review the summary of the **Launch Template**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/15.png?raw=true)

- Choose **Create launch template**.

## Create an Auto Scaling group

In this step, we are going to create an **Auto-Scaling Group** from the **Launch Template** thatv we just created.

- Select the **lab-app-launch-template**, click on **Actions** and click on **Create Auto Scaling group**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/16.png?raw=true)

- On the **Choose launch template or configuration** page, in the **Name** section, for **Auto Scaling group name**, enter `Lab Auto Scaling Group`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/17.png?raw=true)

- Click **Next**.
- On the **Choose instance launch options** page, in the **Network** section, configure the following options:
    - From the **VPC** dropdown list, choose **Lab VPC**.
    - From the **Availability Zones and subnets** dropdown list, choose **Private Subnet 1 (10.0.1.0/24)** and **Private Subnet 2 (10.0.3.0/24)**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/18.png?raw=true)

- Click **Next**.
- On the **Configure advanced options – optional** page, configure the following options: 
    - In the **Load balancing – optional** section, choose **Attach to an existing load balancer**.
    - In the **Attach to an existing load balancer** section, configure the following options:
        - Select **Choose from your load balancer target groups**.
        - From the **Existing load balancer target groups** dropdown list, choose **lab-target-group | HTTP**.
    - In the **Health checks – optional** section, for **Health check type**, choose **ELB**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/19.png?raw=true)

- Click **Next**.
- On the **Configure group size and scaling policies – optional** page, configure the following options: 
    - In the **Group size – optional** section, enter the following values: 
        - **Desired Capacity**: `2`
        - **Minimum Capacity**: `2`
        - **Maximum Capacity**: `4`

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/20.png?raw=true)


- In the Scaling policies – optional section, configure the following options:
    - Choose **Target tracking scaling policy**.
    - For **Metric type**, choose **Average CPU utilization**.
    - Change the **Target value** to `50`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/21.png?raw=true)

- Click **Next**.
- On the **Add notifications – optional** page, choose **Next**.
- On the **Add tags – optional** page, choose **Add tag** and configure the following options:
    - **Key**: Enter `Name`.
    - **Value - optional**: Enter `Lab Instance`.

![App SCreenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/22.png?raw=true)

- Click **Next**.
- Click **Create Auto Scaling group**.

## Verifying that load balancing is working

- In the left navigation pane, locate the **Instances** section, and choose **Instances**.
_You should see two new instances named **Lab Instance**. These instances were launched by auto scaling. If the instances or names are not displayed, wait 30 seconds, and then choose refresh_

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/23.png?raw=true)

- In the left navigation pane, in the **Load Balancing** section, choose **Target Groups**.
- Choose **lab-target-group**.
 _In the **Registered targets** section, two **Lab Instance** targets should be listed for this target group. Wait until the **Health status** of both instances changes to **Healthy**._

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/24.png?raw=true)

- Copy the **DNS name** from the **Load Balancer** page.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/25.png?raw=true)

- Open a new web browser tab, paste the **DNS name** that you copied.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/26.png?raw=true)

_The **Load Test** application should appear in your browser, which means that the load balancer received the request, sent it to one of the EC2 instances, and then passed back the result._

## Testing Auto Scaling

- On the **Load Test** page, click on **Load Test**.

_Now the **Current CPU Load** will go up to 70%._

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/28.png?raw=true)

_You will see now that **two more instances** is created, which means our **Auto Scaling** is working perfectly fine!_

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/Instances.png?raw=true)

## 5. Use Amazon CloudWatch alarms to monitor the performance of your infrastructure.

In this step, I am going to show you how you can monitor the health and performance of your **EC2 Instances** and your whole infrastructure by using **CloudWatch Alarms**.

- In the **AWS Management Console**, in the search bar, enter and choose `CloudWatch`.
- In the left navigation pane, in the **Alarms** section, choose **All alarms**.

_**Two alarms** are displayed. The **Auto Scaling group** automatically created these two alarms. These alarms automatically keep the **average CPU load** close to **50 percent** while also staying within the limitation of having **2–4 instances**._

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/31.png?raw=true)

_You should see that the **AlarmHigh alarm** enters the **In alarm** state._

- Click on this **AlarmHigh alarm**. You should see its details.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Auto-Scaling-and-Load-Balancing/Images/30.png?raw=true)

_That's it! You have now successfully completed this project by **Load Balancing** the traffic between two instances, and also **Scaling Out** your infrastructure based on high demand._



