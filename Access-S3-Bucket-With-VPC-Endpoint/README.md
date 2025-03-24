
# Accessing S3 Bucket From VPC With VPC Endpoint

In this project I am going to show you how you can access S3 buckets from within the VPC via **VPC Endpoint**. 

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/architecture-today.png)

VPC endpoints gives your VPC private, direct access to other AWS services like S3, so traffic doesn't need to go through the internet. Just like how internet gateways are like your VPC's door to the internet, you can think of VPC endpoints as **private doors to specific AWS services**.

## Step-By-Step Project Guide:

- Set Up your Architecture
- Connect to Your EC2 Instance
- Create Access Keys
- Connect to your S3 Bucket
- Create a VPC Endpoint
- Create a Secure Bucket Policy
- Access your S3 Bucket via VPC Endpoint

## 1. Set Up your Architecture

In this section, we will set up our architecture for this project like creaing a VPC, an EC2 instance and an S3 bucket.

## ☁️ Create Your VPC
- Head to your **VPC** console - search for `VPC` at the search bar at top of your page.
- From the left hand navigation bar, select **Your VPCs**.
- Select **Create VPC**.
- Select **VPC and more**.
- Under **Name tag auto-generation**, enter `NextWork`
- The VPC's **IPv4 CIDR block** is already pre-filled to `10.0.0.0/16` - we'll use this default CIDR block!

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step1.1.png)

- For **IPv6 CIDR block**, we'll leave in the default option of **No IPv6 CIDR block**.
- For **Tenancy**, we'll keep the selection of **Default**.
- For **Number of Availability Zones (AZs)**, we'll use just **1** Availability Zone.
- Make sure the **Number of public subnets** chosen is **1**.
- For **Number of private subnets**, we'll keep thing simple today and go with **0** private subnets.
- For the **NAT gateways ($)** option, make sure you've selected **None**. As the dollar sign suggests, NAT gateways cost money!
- For the **VPC endpoints** option, select **None**.
- You can leave the **DNS options** checked.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step1.2.png)

- Select **Create VPC**.

## 💻 Launch an instance in your VPC

- Head to the **EC2 console** - search for `EC2` in the search bar at the top of screen.
- Select **Instances** at the left hand navigation bar.
- Select **Launch instances**.
- Since your first EC2 instance will be launched in your first VPC, let's name it `Endpoint EC2`.
- For the **Amazon Machine Image**, select **Amazon Linux 2023 AMI**.
- For the **Instance type**, select **t2.micro**.
- For the **Key pair (login)** panel, select **Proceed without a key pair (not recommended)**.
- At the **Network settings** panel, select **Edit** at the right hand corner.
- Under **VPC**, select **NextWork-vpc**.
- Under **Subnet**, select your VPC's public subnet.
- Keep the **Auto-assign public IP** setting to **Enable**.
- For the **Firewall (security groups)** setting, choose **Create security group**.
- Name your security group `SG - NextWork VPC Endpoints`

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step1.4.png)

- Select **Launch instance**.

## Launch an Amazon S3 Bucket

- Search for **S3** at the search bar at the top of your console.
- Make sure you're in the **same Region** as your **NextWork VPC**!
- Your **bucket name** should be `nextwork-vpc-endpoints-yourname`. Replace `yourname` with your actual name because S3 bucket names need to be globally unique.
- Select **Create bucket**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step4.2.png)

- Click into your bucket.
- Select **Upload**.
- Select **Add files** in the **Files and folders** panel.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step4.5.png)

- Select two files in your local computer to upload.
- Your files should show up in your **Files and folders** panel once they're uploaded!

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step4.6.png)

- Select **Upload** at the bottom of the page.

## 2. Connect to Your EC2 Instance

In this step, we are going to connect to your EC2 instance and try access S3 through the public internet!

- Head to your **EC2** console and the **Instances** page.
- Select the checkbox next to the **Endpoint EC2**.
- Select **Connect**.
- In the EC2 Instance Connect set up page, select **Connect** again.

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step2.1.png)

## 3. Create Access Keys.

Your EC2 instance needs credentials to access your AWS services, so let's set up access keys right away.

- Search for `IAM` in the search bar.
- Search for `Access keys` in the IAM console's left hand navigation panel.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step3.2.png)

- Choose **Access Keys** and click **Create Access Key**

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step3.3.png)

- On the first set up page, select **Command Line Interface (CLI)**.
- Select the checkbox that says **I understand the above recommendation and want to proceed to create an access key**.
- Click **Next**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step3.4.png)

- For the **Description tag value**, we'll write `Access key created to access an S3 bucket from an EC2 Instance. NextWork VPC Endpoints project`.
- Select **Create access key**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step3.5.png)

- Select **Download .csv file** near the bottom of the page.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step3.6.png)

- Click **Done**.

## 4. Connect to your S3 Bucket

In this step, we are going to configure our Access Keys into the **EC2 CLI** and **connecting to our S3 bucket**.

- Now back to your **EC2 Instance Connect tab**!
- Run `aws configure` command to configure your access key.
- Open the **AccessKeys.csv file** you've downloaded.
- Copy & Paste the **Access Key ID** and **Secret Access Key**.
- Next, for your **Default region name**, open your **Region** dropdown on the top right hand corner of your AWS console, and copy your **Region's code name**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step5.2.png)

- We don't have a default output format, so we can leave that empty. Press **Enter**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step5.3.png)

- Now let's run `aws s3 ls` again.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Access-S3-Bucket-With-VPC-Endpoint/Images/3.png?raw=true)

- Next, let's run the command `aws s3 ls s3://nextwork-vpc-endpoints-yourname`. Make sure to replace `nextwork-vpc-endpoints-yourname` with your actual bucket name!

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Access-S3-Bucket-With-VPC-Endpoint/Images/4.png?raw=true)

- Run `sudo touch /tmp/nextwork.txt` to create a blank .txt file in your EC2 instance.

- Next, run `aws s3 cp /tmp/nextwork.txt s3://nextwork-vpc-endpoints-yourname` to upload that file into your bucket.
- Run `aws s3 ls s3://nextwork-vpc-endpoints-yourname` to confirm that the file is uploaded.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Access-S3-Bucket-With-VPC-Endpoint/Images/522.png?raw=true)

- Switch tabs back to your **S3** console and refresh the page to see the file uploaded.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step5.7.png)

## 5. Create a VPC Endpoint

In this step, we are going to create the main service of this project (i.e the VPC Endpoint) to securely connect to our S3 bucket from within our VPC.

- Head back to your **VPC** console.
- Select **Endpoints** from the left hand navigation panel.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step6.1.png)

- Select **Create endpoint**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step6.2.png)

- For the **Name tag**, let's use `NextWork VPC Endpoint`.
- Keep the **Service category** as **AWS services**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step6.3.png)

- In the **Services** panel, search for **S3**.
- Select the filter result that just ends with **s3**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step6.4.png)

- Select the row with the **Type** set to **Gateway**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step6.5.png)

- Next, at the **VPC** panel, select **NextWork-vpc**.
- We'll leave the remaining default values and select **Create endpoint**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step6.6.png)

## 6. Create a Secure Bucket Policy

In this step, we're going to **block off your S3 bucket from ALL traffic**... except traffic coming from the endpoint by creating a secure bucket policy for your S3 bucket.

- In the **S3** console, select **Buckets** from the left hand navigation panel.
- Click into your bucket **vpc-endpoints-yourname**.
- Select the **Permissions** tab.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step7.1.png)

- Scroll to the **Bucket policy** panel, and select **Edit**.
- Add the below bucket policy to the policy editor.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ],
      "Condition": {
        "StringNotEquals": {
          "aws:sourceVpce": "vpce-xxxxxxx"
        }
      }
    }
  ]
}
```

- Don't forget to replace **Both instances** of **arn:aws:s3:::your-bucket-name** with your actual bucket ARN.
    - Handy tip: you can find your Bucket ARN right above the Policy window

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step7.3.png)

- Also replace **vpce-xxxxxxx** with your **VPC endpoint's ID**.
    - To find this ID, you'll have to switch back to your **Endpoints** tab and copy your endpoint's ID. Make sure it starts with `vpce-`

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step7.4.png)

- Select **Save changes**.
- Once you've saved your changes, panels have turned red all across the screen.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step7.7.png)

_Well, your policy denies all actions unless they come from your VPC endpoint. This means any attempt to access your bucket from other sources, including the AWS Management Console, is blocked!_ 

## 7. Access your S3 Bucket via VPC Endpoint

In this step, we are going to configure our **VPC's Subnet Route Table** to redirect traffic to S3 via VPC Endpoint. Then, we will be able to access our S3 Bucket.

- Head to the `VPC` console.
- Select **Endpoints** from the left hand navigation panel.
- Select the checkbox next to your endpoint, and select **Route tables**.
- Select **Manage route tables**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step8.3.png)

- Select the checkbox next to your public route table.
- Select **Modify route tables**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step8.4.png)

- Head to the **Subnets** page.
- Select your public subnet, which starts with **NextWork-subnet-public1**.
- Select the **Route table** tab to confirm it.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step8.5.png)

- Back in your **EC2 Instance Connect** tab, run `aws s3 ls s3://nextwork-vpc-endpoints-yourname`.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Access-S3-Bucket-With-VPC-Endpoint/Images/523.png?raw=true)

_Congrats on making a successful VPC endpoint connection!_

> [!IMPORTANT]
> Now you cannot delete your S3 bucket from the AWS console. You can only delete your S3 bucket from your EC2 now. Let's see that in action!

- Head to your **S3** console.
- Select the **Buckets** page.
- Select your **nextwork-vpc-endpoints-yourname**, and select Delete.
- Enter your bucket name, and select **Delete bucket**.
- You will now receive an **ACCESS DENIED** error.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-endpoints/high-step11.1.png)

- Switch tabs to your instance's terminal.
- To delete everything in your bucket, run the command `aws s3 rm s3://nextwork-vpc-endpoints-yourname --recursive`.
- Run the command `aws s3 rb s3://nextwork-vpc-endpoints-yourname` to delete your bucket.
- Confirm it by running `aws s3 ls` again.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Access-S3-Bucket-With-VPC-Endpoint/Images/Screenshot%202025-03-24%20063920.png?raw=true)

_Congrats! You have successfully completed this project by by accessing an S3 bucket via VPC Endpoint for better security, latency and cost optimization._ 

_Follow for more such AWS projects!_
