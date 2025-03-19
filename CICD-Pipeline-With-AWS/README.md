
# CI/CD Pipeline with AWS

In this AWS project, I will build a CI/CD pipeline using AWS and Github.



![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-cicd/aws-cicd.png)





## Roadmap

- Set Up a Web App in the Cloud

- Connect a GitHub Repo with AWS

- Secure Packages with CodeArtifact

- Continuous Integration with CodeBuild

- Deploy a Web App with CodeDeploy

- Build a CI/CD Pipeline with AWS


## 1. Setup a Web App in the Cloud

First, I launch an EC2 instance which I will be using to build my Web App on it and all of my files for my Web App will be on this EC2 instance.



![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/EC2-1.png)

Then I SSH into my EC2 instance from VSCode Terminal. For this I changed the permissions of "PEM Key" using the following commands:




```bash
icacls "nextwork-keypair.pem" /reset
icacls "nextwork-keypair.pem" /grant:r "USERNAME:R"
icacls "nextwork-keypair.pem" /inheritance:r

```

Now to SSH into your EC2, use this command:
```bash
ssh -i [PATH TO YOUR .PEM FILE] ec2-user@[YOUR PUBLIC IPV4 DNS]
```

Now I am going to install Apache Maven and Amazon Corretto 8.


## What is Apache Maven?

Apache Maven is a tool that helps developers build and organize Java software projects. It's also a package manager, which means it automatically download any external pieces of code your project depends on to work.

We're also using Maven today because it's really useful for kick-starting web projects! It uses something called archetypes, which are like templates, to lay out the foundations for different types of projects e.g. web apps.

We'll use Maven later on to help us set up all the necessary web files to create a web app structure, so we can jump straight into the fun part of developing the web app sooner.

## Install Apache Maven

```bash
wget https://archive.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz

sudo tar -xzf apache-maven-3.5.2-bin.tar.gz -C /opt

echo "export PATH=/opt/apache-maven-3.5.2/bin:$PATH" >> ~/.bashrc

source ~/.bashrc

```
Now I am going to install Java 8, or more specifically, Amazon Correto 8.

## What is Java? What is Amazon Corretto 8?

Java is a popular programming language used to build different types of applications, from mobile apps to large enterprise systems.

Maven, which we just downloaded, is a tool that NEEDS Java to operate. So if we don't install Java, we won't be able to use Maven to generate/build our web app today.

Amazon Corretto 8 is a version of Java that we're using for this project. It's free, reliable and provided by Amazon.

## Install Amazon Corretto 8
```bash
sudo dnf install -y java-1.8.0-amazon-corretto-devel

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64

export PATH=/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64/jre/bin/:$PATH
```

To verify that Maven is installed correctly, I run the following command next:
```bash
mvn -v
```

To verify that I have installed Java 8 correctly, I run this command next:
```bash
java -version
```

## Create the applications
To create the Web application, I run these Maven commands in the terminal to generate a Java web app.
```bash
mvn archetype:generate \
-DgroupId=com.nextwork.app \
-DartifactId=nextwork-web-project \
-DarchetypeArtifactId=maven-archetype-webapp \
-DinteractiveMode=false
```

## Connect VS Code with the EC2 Instance
In this step I am going to do the following tasks:

1. Install an extension in VS Code.
2. Use the extension to set up a connection between VS Code and the EC2 instance.
3. Explore and edit my Java web app's files using VS Code.

## 
For this I first install this extension in VSCode:


![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.2.png)

Click on the double arrow icon at the bottom left corner of VS Code window. This button is a shortcut to use Remote - SSH.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.3.png)

- Select Connect to Host...



- Select + Add New SSH Host...

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.4.png)

- Select the configuration file at the top of my window. It should look similar to /Users/username/.ssh/config
![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/7.5.png)

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/7.6.png)

