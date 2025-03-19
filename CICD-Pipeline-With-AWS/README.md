
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

- Now I am ready to connect VSCode with my EC2 instance!
- Click on the double arrow button on the bottom left corner and select Connect to Host again.
- Now it's showing my EC2 instance.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.7.png)

- Check the bottom right hand corner of my new VSCode window - it's showing my EC2 instance's IPV4 DNS.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.9.png)

- From VSCode's left hand navigation bar, select the Explorer icon.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.10.png)

- Select Open folder.
- At the top of the VSCode window, there is a drop down of different file and folder names.
- Enter /home/ec2-user/nextwork-web-project.
- Press OK.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.11.png)

- Now it is showing my Web App on my EC2 instance:
![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.15.png)

## Updating my Web App

```bash
<html>

<body>

<h2>Hello World!</h2>

<p>This is my NextWork web application working!</p>

</body>

</html>
```





## 2. Connect a GitHub Repo with AWS
Now in this phase, I'll do the following steps:
1. Set up Git and GitHub.
2. Connect my web app project to a GitHub repo.
3. Make changes to my web app code - and watch my GitHub repo update too.

## 
For this, I have to install Git on my EC2 instance first:
```bash
sudo dnf update -y
sudo dnf install git -y
```

To verify the installation, I run this command:
```bash
git --version
```

Now I have to create a Github Repo.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/Git%20Repo.png)
## 
Now to setup a local git repo in my web app folder I'll run this command:
```bash
git init
```

Run this command to link your github repo to your local git. Don't forget to replace [YOUR GITHUB REPO LINK] with the link of your github repo.
```bash
git remote add origin [YOUR GITHUB REPO LINK]
```

Next, I'll save my changes and push them into GitHub.
```bash
git add . 
git commit -m "Updated index.jsp with new content"
git push -u origin master
```

- Now in the mean time, set up a Github Token doing the following steps:
1. Click Settings.


![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/Github%20Token.png)

2. Click on Developer Settings.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/Github%20Token%202.png)

3. Select Generate new token (classic).

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-github/5.9.png)

4. Configure it as:

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG12.png)

## 

- For USERNAME paste your Github USERNAME
- For Password paste the Github Token

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG1122.png)


- The change is now successfully pushed!

![App SCreenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG1322.png)

## Setup your Name & Email

Use the following commands to setup your "Name" & "Email" so that you can keep track of who makes these changes:
```bash
git config --global user.name "Your Name"
git config --global user.email youremail@gmail.com
```

- Also run the following command to configure Git to use the store credential helper to store your credentials:
```bash
git config --global credential.helper store
```


## 3. Set Up AWS CodeArtifact Repository

Now, let's set up AWS CodeArtifact, a fully managed artifact repository service. We'll use it to store and manage our project's dependencies, ensuring secure and reliable access to Java packages.

This is important because CodeArtifact provides a centralized, secure, and scalable way to manage dependencies for our Java projects, improving build consistency and security.

- Head to the CodeArtifact service in the AWS management console.
- Click on Create Repository.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-143.png)

- On the Create repository page, head to the Repository configuration section.
- In the Repository name field, enter nextwork-devops-cicd.
- In the Repository description - optional field, enter: This repository stores packages related to a Java web app created as a part of NextWork's CI/CD Pipeline series.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-145.png)

- Under Public upstream repositories - optional, select the checkbox next to maven-central-store.
- This will configure Maven Central as an upstream repository for your CodeArtifact repository.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-146.png)

## What is Maven Central?
Maven Central is essentially the App Store of the Java world - it's the most popular public repository where developers publish and share Java libraries. When you're building Java applications, chances are you'll need packages from Maven Central. It contains virtually every popular open-source Java library out there, from database connectors to testing frameworks and UI components.

By connecting our CodeArtifact repository to Maven Central, we're setting up a system where we get the best of both worlds: access to all these public libraries, but with the added benefits of caching, control, and consistency that come with our private CodeArtifact repository.

- Click Next.
- You're now ready to set up your CodeArtifact domain!

## What is a CodeArtifact Domain?
A CodeArtifact domain is like a folder that holds multiple repositories belonging to the same project or organization. We like using domains because they give you a single place to manage permissions and security settings that apply to all repositories inside it. This is much more convenient than setting up permissions for each repository separately, especially in large companies where many teams need access to different repositories.

With domains, you can ensure consistent security controls across all your package repositories in an efficient way.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-147.png)

- Under Domain selection, choose This AWS account.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-148.png)

- Under Domain name, enter nextwork.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-149.png)

- Click Next to proceed.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-150.png)

- Now we're on the last page! Let's Review and create.
- Review the details of your repository configuration, including the package flow at the top.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG15.png)

## What is this package flow diagram?
The package flow diagram shows you exactly how dependencies will travel to your application. When your project needs a dependency, it first looks in your CodeArtifact repository. If the package is already there, great! It uses that version. If not, CodeArtifact automatically reaches out to Maven Central to fetch it.

This is important to understand because it affects how quickly your builds run and how resilient they are to network issues. The first time you request a package, it might take a moment longer as CodeArtifact fetches it from Maven Central. But every build afterwards will be faster because the package is now cached in your repository. It's like the difference between ordering groceries for delivery versus already having them in your fridge!
## 
- Select the Create repository button to create your CodeArtifact repository.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-155.png)

## Create an IAM Policy for CodeArtifact Access
For Maven to start working with CodeArtifact, we need to create an IAM role that grants our EC2 instance the permission it needs to access CodeArtifact.

Otherwise, Maven can try all it wants to command your EC2 instance to store and retrieve packages from CodeArtifact, but your EC2 instance simple wouldn't be able to do anything! And going another layer deeper, IAM roles are made of policies; so we need to create policies first before setting up the role.
## 
- In the AWS Management Console, head to the the IAM console.
- In the IAM console, in the left-hand menu, click on Policies.
- Click the Create policy button to start creating a new IAM policy.
![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-212.png)

- On the Create policy page, select the JSON tab.
- Replace the default content in the text editor with the following JSON policy document. Copy and paste the entire JSON code block:
```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codeartifact:GetAuthorizationToken",
                "codeartifact:GetRepositoryEndpoint",
                "codeartifact:ReadFromRepository"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sts:GetServiceBearerToken",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "sts:AWSServiceName": "codeartifact.amazonaws.com"
                }
            }
        }
    ]
}
```

- After pasting the JSON policy document, click the Next button at the bottom right.
![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-214.png)

- On the Review policy page, in the Policy name field, enter codeartifact-nextwork-consumer-policy.
- In the Description - optional field, add a description like: Provides permissions to read from CodeArtifact. Created as a part of NextWork CICD Pipeline series.
![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-216.png)

- Review the Summary of your policy to ensure the permissions and details are correct.
![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-218.png)

- Click the Create policy button to create the IAM policy.
![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-219.png)

## Attach IAM Policy and Verify CodeArtifact Connection

In this step, you're going to:





- Create a new IAM role for EC2 that has your new policy attached.
- Attach the IAM role to your EC2 instance.
- Re-run the export token command, this time seeing a successful response

In the IAM console, in the left-hand menu, click on Roles.

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-164.png)

- Click the Create role button to start creating a new IAM role.
- For Select entity type, choose AWS service.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-165.png)

- Under Choose a use case, select EC2 from the list of services.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-166.png)

- Click Next to proceed to the Add permissions step.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-167.png)

- In the Add permissions step, in the Filter policies search box, type codeartifact-nextwork-consumer-policy.
- Select the checkbox next to the codeartifact-nextwork-consumer-policy that you created in the previous step.
- Click Next to head to the Name, review, and create step.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-170.png)

In the Name, review, and create step:

- In the Role name field, enter EC2-instance-nextwork-cicd.
- In the Description - optional field, enter: Allows EC2 instances to access services related to the NextWork CI/CD pipeline series.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-171.png)

- Next, in the review page, click the Create role button to create the IAM role.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-174.png)

- Now, we need to associate this IAM role with your EC2 instance.
- Head back to the EC2 console. And in the Instances tab, select the EC2 which has your application.
- Click on Actions in the menu bar, then select Security, and then Modify IAM role.
- Under IAM role, select the IAM role you just created, EC2-instance-nextwork-cicd, from the dropdown menu.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-181.png)

- Select Update IAM role to attach the role to your EC2 instance.

## Re-run export token command

Now that your EC2 instance has the necessary IAM role attached, let's re-run the command to export the CodeArtifact authorization token.

This time, your EC2 instance should be able to retrieve the token, since it has the necessary permissions from the IAM role.

- Head back to your VS Code terminal connected to your EC2 instance.
- Re-run the same export token command from Step 3.
- This command will retrieve a temporary authorization token for CodeArtifact and store it in an environment variable named CODEARTIFACT_AUTH_TOKEN.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-188.png)



## See Packages in CodeArtifact!

Let's make sure everything is set up correctly by verifying the connection to our CodeArtifact repository from our EC2 instance. We'll configure Maven to use CodeArtifact and then try to compile our web app, which should now download dependencies from CodeArtifact.

This verification is crucial to ensure that our EC2 instance can successfully access and retrieve packages from CodeArtifact, which is a key part of our CI/CD pipeline setup.

- In VS Code, in your left hand file explorer, head to the root directory of your nextwork-web-project.
- Create a new file at the root of your nextwork-web-project directory named settings.xml

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-192.png)

## What is settings.xml?

settings.xml is like a settings page for Maven - it stores all the settings we saw in Steps 4-6 of the connection window. It tells Maven how to behave across all your projects. In our case, we need a settings.xml file to tell Maven where to find the dependencies and how to get access to the right repositories (e.g. the ones in CodeArtifact).

💡 Extra for Experts: What's xml?
xml is a markup language that lets you structure data and write instructions for a server. It's just like how html is a markup language that lets you structure data and write instructions for a web browser to display a web page.

You might also notice pom.xml, which is a file that was automatically created in your repository's root directory when you set up your web app for the first time.

pom.xml tells Maven the ingredients list (i.e. dependencies) for your web app and how to put them together to build the app. Then, once Maven knows what dependencies to look for, settings.xml tells Maven where to find the dependencies and how to get access to the right repositories (e.g. the ones in CodeArtifact).
##

- Open the settings.xml file. If you created a new file, it will be empty.
- In your settings.xml file, add the <settings> root tag if it's not already there:
```bash
<settings>
</settings>
```
- Go back to the CodeArtifact connection settings panel.
- From the Connection instructions dialog, copy the XML code snippet from Step 4: Add your server to the list of servers in your settings.xml.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-200.png)

- Paste the code in the settings.xml file, in between the <settings> tags.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-194.png)

- Let's copy the XML code snippet from Step 5: Add a profile containing your repository to your settings.xml.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-201.png)

- Paste the code snippet you copied right underneath the <servers> tags. Make sure the <profiles> tags are also nested inside the <settings> tags.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-196.png)

- Finally, paste the XML code snippet from Step 6: (Optional) Set a mirror in your settings.xml... right underneath the <profiles> tags.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-199.png)

- Save the settings.xml file.

## Compile your project and verify the CodeArtifact integration

- Run the Maven compile command, which uses the settings.xml file we just configured:
```bash
mvn -s settings.xml compile
```

- You should see messages like Downloading from nextwork-devops-cicd telling us that Maven is downloading dependencies from your CodeArtifact repository. This is a good sign that Maven is using CodeArtifact to manage dependencies!
- If the compilation is successful and dependencies are downloaded from CodeArtifact, you'll see a BUILD SUCCESS message at the end of the Maven output.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/6.1.png)

- Now head back to the CodeArtifact console in your browser.
- Close the connection instructions window.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-206.png)

- Click the refresh button in the top right corner of the Packages pane.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-208.png)

- Now you'll see all the dependencies of your web application.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG17.png)

- These are the dependencies that Maven downloaded from Maven Central via CodeArtifact when you compiled your project.
- Congrats! This confirms that your CodeArtifact setup is working correctly and that Maven is using it to manage dependencies 💪
