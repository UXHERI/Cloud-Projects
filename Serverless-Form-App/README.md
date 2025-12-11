
# Serverless Form Web App

In this mini project I am going to show you how I built a **serverless** web app that scales with the user demand and add data to a **DynamoDB** table.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/Infra.png?raw=true)

This project is originally done by **Harish Shetty** and the **Lambda** function code is also in his [Github Repo](https://github.com/harishnshetty/serverless-lambda-apigateway-aws-mini-project).

## Step-by-Step Project Guide

- Create a DynamoDB table
- Create an IAM Role for Lambda
- Create a Lambda Function
- Create an API Gateway

## 1. Create a DynamoDB table

The first step is to create a **DynamoDB** table to store the user data.

- Go to **AWS Management Console** → **DynamoDB** → **Tables**.
- Click **Create table**.
- Name it anything you want; I named it `uxheri`.
- Select the **Partition key** as `email`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/1.png?raw=true)

- Click **Create table**.

## 2. Create an IAM Role for Lambda

In the second step, let's create an **IAM Role** for the **Lambda** function so that it can perform the required tasks.

- Go to **AWS Management Console** → **IAM** → **Roles**.
- Click **Create role**.
- Select the **Trusted entity type** as `AWS service`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/2.png?raw=true)

- Select the **Use case** as `Lambda`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/3.png?raw=true)

- Click **Next**.
- In **Add permissions** select `AdministratorAccess` policy.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/4.png?raw=true)

- Click **Next**.
- Name it: `Lambda_Role`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/5.png?raw=true)

- Click **Create role**.

## 3. Create a Lambda Function

In the third step, we will be creating a **Lambda** function for this serverless app.

- Go to **AWS Management Console** → **Lambda** → **Functions**.
- Click **Create function**.
- Select `Author from scratch`.
- Enter the **Function name** as `Serverless-App`.
- Select the **Runtime** as `Python 3.13`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/6.png?raw=true)

- In the **Execution role** select the `Lambda_Role` that we have just created.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/7.png?raw=true)

- Click **Create function**.
- Now in this function, go to **Configuration** → **Edit basic settings**.
- Update the **Timeout** to `15 minutes`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/8.png?raw=true)

- Now go to **Code**.
- Delete the existing code.
- Right click and select **Upload**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/16.png?raw=true)

- Upload this [Cloned code](https://github.com/harishnshetty/serverless-lambda-apigateway-aws-mini-project.git).
- Click **Deploy**.

## 4. Create an API Gateway

In this final step, create an **API Gateway** to access the web app.

- Go to **AWS Management Console** → **API Gateway**.
- Click **Create an API**.
- Select **Rest API**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/9.png?raw=true)

- Click **Build**.
- Name the **API** as `Serverless-App`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/10.png?raw=true)

- Now go to **Resources**.
- Click **Create method**.
- Select the **Method type** as `GET`.
- Select the **Integration type** as `Lambda function`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/11.png?raw=true)

- Select the **Lambda proxy integration**.
- In the **Lambda function** select the `Serverless-App`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/12.png?raw=true)

- Click again **Create method**.
- Select the **Method type** as `POST`.
- Select the **Integration type** as `Lambda function`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/13.png?raw=true)

- Select the **Lambda proxy integration**.
- In the **Lambda function** select the `Serverless-App`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/14.png?raw=true)

- Click on **Deploy API**.
- Select the **stage** as `New stage`.
- Enter the **Stage name** as `dev`.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/15.png?raw=true)

- Click **Deploy**.
- Now copy the **Invoke URL**.
- Paste it into the web browser.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/17.png?raw=true)

- Enter the user data and click **Submit**.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/18.png?raw=true)

_Your data is now uploaded to the **DynamoDB** table_.

- Go to the **DynamoDB** table to confirm it.

![](https://github.com/UXHERI/Cloud-Projects/blob/main/Serverless-Form-App/Images/19.png?raw=true)

_You have now successfully built a **serverless** application on **AWS** which adds user data into a **DynamoDB** table and scales with demand._
