
# Deploy an App on Kubernetes with AWS

In this project I am going to show you how you can deploy a simple application on Kubernetes with Amazon EKS.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/architecture-done.png?raw=true)

## Step-by-Step Project Guide:

- Launch and connect to an EC2 instance.
- Create a Kubernetes cluster.
- Access your cluster using an IAM access entry.
- Clone a backend application from GitHub.
- Build a Docker image of the backend.
- Push your image to an Amazon ECR repository.
- Set up a Deployment manifest & Service manifest.
- Deploy the backend on a Kubernetes cluster.
- Track your Kubernetes deployment using EKS.

## 1. Launch and connect to an EC2 instance.

In this first step, I am going to show you how to create your EC2 instance which you will use to create Kubernetes cluster.

- Log into your AWS Management Console as your IAM Admin user.
- Head to `EC2` in your AWS Management Console.
- Select `Instances` at the left hand navigation bar.
- Select **Launch instances** at the top right corner of your console.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_3.png)

- Name your EC2 instance `nextwork-eks-instance`.
- For the **Amazon Machine Image**, select **Amazon Linux 2023 AMI**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_4.png)

- For the **Instance type**, select **t2.micro**.
- For the **Key pair (login)** panel, select **Proceed without a key pair (not recommended)**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_6.png)

- Keep the **Networking** section as **Default**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_7.png)

- Select **Launch instances**.
- Select the instance you just launched.
- Select the checkbox next to **nextwork-eks-instance**.
- Select the **Connect** button.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_9.png)

- Select **EC2 Instance Connect**.
- Select **Connect** at the bottom of the page.

## 2. Launch an EKS cluster

In this step, I am going to show you how you can create an **EKS (Elastic Kubernetes Service)** cluster from your EC2 instance CLI.

- Run these commands in your terminal to install **eksctl**:

```bash
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
```

- Check that eksctl is installed correctly by running `eksctl version`.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/2.png?raw=true)

## Set up your EC2 instance's IAM role.

- In a new tab, head to your `AWS IAM` console.
- Select **Roles** from the left hand sidebar.
- Select **Create role**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_17.png)

- Under **Trusted entity type**, select **AWS service** to tell AWS that we're setting up this role for a AWS serice (Amazon EC2).
- Under **Use case**, select **EC2**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_48.png)

- Select **Next**.
- Under **Permissions policies**, we'll grant our EC2 instance **AdministratorAccess**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_49.png)

- Make sure the **AdministratorAccess** option is checked, and select **Next**.
- Let's give this role a name - `nextwork-eks-instance-role`.
- Enter a short description:

```text
Grants an EC2 instance AdministratorAccess to my AWS account. Created during NextWork's Kubernetes project.
```

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_50.png)

- Select **Create role**.

## Attach IAM role to EC2 instance

- Head back to the **Amazon EC2** console.
- Select **Instances** from the left hand sidebar.
- Select the checkbox next to your **nextwork-eks-instance** EC2 instance.
- Select the **Actions** dropdown, and then **Security** -> **Modify IAM role**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_20.png)

- Under **IAM role**, select your new `nextwork-eks-instance-role` role.
- Select **Update IAM role**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_21.png)

## Create an EKS cluster

- head back to your **EC2 Instance Connect** tab.
- Run these commands:

```bash
eksctl create cluster \
--name nextwork-eks-cluster \
--nodegroup-name nextwork-nodegroup \
--node-type t2.micro \
--nodes 3 \
--nodes-min 1 \
--nodes-max 3 \
--version 1.31 \
--region [YOUR-REGION]
```

_Make sure to replace **YOUR REGION** with your **AWS region code**._

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_22.png)

## Track How AWS Creates Your EKS Cluster

- Use **CloudFormation** to track how your cluster is getting created.
- In a new tab, head to the `CloudFormation` console.
- In the **Stacks** page, notice that there is a new stack in progress! The stack should be called **eksctl-nextwork-eks-cluster-cluster**.
- Select the stack, and track the **Events** tab.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_44.png)

- Now select the **Resources** tab.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_24.png)

- You might also notice a NEW stack pop up in the Stacks page. This should pop up 10-12 minutes from the time you ran the `create cluster` command.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_25.png)

- Wait for both of them to be completed!

## 3. Access EKS from the Management Console

In this step, we are going to configure **IAM access entry** to access our EKS cluster.

- Open the `EKS` console.
- Select the new **nextwork-eks-cluster** cluster you just created.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/5.png?raw=true)

- Select the **Compute** tab.
- Scroll down to the **Node groups** panel.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/7.png?raw=true)

- In the **Access** tab, scroll down to **IAM access entries**.
- Select **Create access entry**.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/22.png?raw=true)

- Under **IAM Principal**, select your IAM user's ARN. Double check your IAM Admin's name at the top right corner and make sure it matches your ARN.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/6.png?raw=true)

- Select **Next**.
- Under **Policy name**, select `AmazonEKSClusterAdminPolicy`.
- Select **Add policy**.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_30.png)

- Select **Next**.
- Select **Create**.
- Head back to your cluster's page.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks1/processed_image_29.png)

- Select the refresh button on the console. You should now see your nodes listed under your node group.

## 4. Clone a Backend Application from GitHub.

In this step, we are going to pull a simple backend application from Github repository.

- Head back to your **EC2 Instance Connect** session.
- Install Git:

```bash
sudo dnf update
sudo dnf install git -y
```

- Verify you've downloaded Git by checking for its version:

```bash
git --version
```

- Configure Git by running the command below. Make sure to replace the placeholder values with your name and email:

```bash
git config --global user.name "NextWork"
git config --global user.email "yourname@nextwork.example"
```

- Now clone the github repository:

```bash
git clone https://github.com/NatNextWork1/nextwork-flask-backend.git
```

- Run `ls` to check your repository.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/9.png?raw=true)

## 5. Build a Container Image for Your Backend

In this step, we will be creating a **Container Image** for Kubernetes.

- Install Docker:

```bash
sudo yum install -y docker
```

- Start Docker:

```bash
sudo service docker start
```

- Add **ec2-user** to the **Docker** group:

```bash
sudo usermod -a -G docker ec2-user
```

- Restart your **EC2 Instance Connect** session by refreshing your current tab.

- Make sure your ec2-user has been added to the **Docker** group:

```bash
groups ec2-user
```

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks2/ec2-user.png)

- Navigate to the application directory, which contains the Dockerfile:

```bash
cd nextwork-flask-backend
```

- Run the command to build your Docker image:

```bash
docker build -t nextwork-flask-backend .
```

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/13.png?raw=true)

_Your Container Image is built._

## 6. Push Your Container Image to Amazon ECR

In this step, We are going to push our container image to Amazon ECR which is a storage space for container images.

- Create a new Amazon ECR repository using this command:

```bash
aws ecr create-repository \
  --repository-name nextwork-flask-backend \
  --image-scanning-configuration scanOnPush=true \
```

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/14.png?raw=true)

- In a new tab, head to the `ECR` console.
- Confirm that you can see a new repository called **nextwork-flask-backend**.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/23.png?raw=true)

- Select your new repository.
- Select **View push commands**.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/24.png?raw=true)

- Copy the 1, 3 & 4 commands.
- Run these commands in your **EC2 Instance Connect** window.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/15.png?raw=true)

- Head back to the **ECR** console.
- Click the **Refresh** button.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks4/processed_image_22.png)

- Confirm that a new container image is in your console now.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/16.png?raw=true)

## 7. Create Kubernetes Manifest Files

In this step, we will be creating **manifest** files, which tell Kubernetes how to run your application in a cluster.

- Run these commands to create a directory:

```bash
cd ..
mkdir manifests
cd manifests
```

- Create the `flask-deployment.yaml` file:

```bash
cat << EOF > flask-deployment.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nextwork-flask-backend
  namespace: default
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nextwork-flask-backend
  template:
    metadata:
      labels:
        app: nextwork-flask-backend
    spec:
      containers:
        - name: nextwork-flask-backend
          image: YOUR-ECR-IMAGE-URI-HERE
          ports:
            - containerPort: 8080
EOF
```

- Run `nano flask-deployment.yaml` in your terminal to see your work.

- Notice the third to last line... Replace **[YOUR-ECR-IMAGE-URI-HERE]** with the **Image URI** of your image.

![Image](https://learn.nextwork.org/projects/static/aws-compute-eks4/processed_image_20.png)

- Your updated **flask-deployment.yaml** file should look like this:

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/17.png?raw=true)

- Press **Ctrl + S** on your keyboard to save your work.
- Press **Ctrl + X** to exit out of the file.

- Create the **flask-service.yaml** file:

```bash
cat << EOF > flask-service.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: nextwork-flask-backend
spec:
  selector:
    app: nextwork-flask-backend
  type: NodePort
  ports:
    - port: 8080
      targetPort: 8080
      protocol: TCP
EOF
```

## 8. Deploy Your Backend Application

In this step, we are going to deploy our app by using a command line tool called **kubectl**. So, we will first install this tool.

- Install **kubectl**:

```bash
sudo curl -o /usr/local/bin/kubectl \
https://s3.us-west-2.amazonaws.com/amazon-eks/1.31.0/2024-09-12/bin/linux/amd64/kubectl
```

- Just like what you did with Docker, you'll need to give yourself the permission to use kubectl:

```bash
sudo chmod +x /usr/local/bin/kubectl
```

- Check you've installed kubectl properly:

```bash
kubectl version
```

- Run the commands to apply your manifest files:

```bash
kubectl apply -f flask-deployment.yaml
kubectl apply -f flask-service.yaml
```

_You've just used kubectl to apply your manifest files, which deploys your app across your cluster._

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/20.png?raw=true)

## 9. Track your Kubernetes deployment using EKS.

In this step, we are going to verify our Kubernetes deployment through EKS.

- In a new tab, open up the `EKS` console.
- Select the **nextwork-eks-cluster** cluster you've created for this project.
- Select the **Compute** tab.
- Scroll down to the **Node groups** panel. You should now see your nodes listed under your node group.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/25.png?raw=true)

- Click into one of the nodes to view its details.
- Scroll down to the **Pods** section.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/26.png?raw=true)

- Select the pod that starts with **demo-flask-backend-xxxxx**.
- Check out the **Events** section to see the latest updates for this pod.

![Image](https://github.com/UXHERI/Cloud-Projects/blob/main/Deploy-an-App-on-Kubernetes-with-AWS/Images/21.png?raw=true)

_That's it! We have successfully deployed the backend of our app but we will not be accessing that in this project. This was just to show you the process of deploying an application on Kubernetes. I will definitely upload some more projects on Kubernetes and how to deploy production apps on Kubernetes. **STAY TUNED!**_

