# CI/CD Pipeline with AWS

In this AWS project, I will build a CI/CD pipeline using AWS and Github.



![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/architecture-complete.png)





## Roadmap

- Set Up a Web App in the Cloud

- Connect a GitHub Repo with AWS

- Secure Packages with CodeArtifact

- Continuous Integration with CodeBuild

- Deploy a Web App with CodeDeploy

- Build a CI/CD Pipeline with AWS


## 1. Setup a Web App in the Cloud

- First, I launch an EC2 instance which I will be using to build my Web App on it and all of my files for my Web App will be on this EC2 instance.



![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/EC2-1.png)

- Then I SSH into my EC2 instance from VSCode Terminal. For this I changed the permissions of "PEM Key" using the following commands:




```bash
icacls "nextwork-keypair.pem" /reset
icacls "nextwork-keypair.pem" /grant:r "USERNAME:R"
icacls "nextwork-keypair.pem" /inheritance:r

```

- Now to SSH into your EC2, use this command:
```bash
ssh -i [PATH TO YOUR .PEM FILE] ec2-user@[YOUR PUBLIC IPV4 DNS]
```

- Now I am going to install **Apache Maven** and **Amazon Corretto 8**.


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
- Now I am going to install Java 8, or more specifically, Amazon Correto 8.

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

- To verify that Maven is installed correctly, I run the following command next:
```bash
mvn -v
```

- To verify that I have installed Java 8 correctly, I run this command next:
```bash
java -version
```

## Create the applications
- To create the Web application, I run these Maven commands in the terminal to generate a Java web app.
```bash
mvn archetype:generate \
-DgroupId=com.nextwork.app \
-DartifactId=nextwork-web-project \
-DarchetypeArtifactId=maven-archetype-webapp \
-DinteractiveMode=false
```

## Connect VS Code with the EC2 Instance
- In this step I am going to do the following tasks:

1. Install an extension in VS Code.
2. Use the extension to set up a connection between VS Code and the EC2 instance.
3. Explore and edit my Java web app's files using VS Code.

## 
- For this I first install this extension in VSCode:


![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/7.2.png)

- Click on the double arrow icon at the bottom left corner of VS Code window. This button is a shortcut to use **Remote-SSH**.

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
- Enter `/home/ec2-user/nextwork-web-project`.
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
- Now in this phase, I'll do the following steps:
1. Set up Git and GitHub.
2. Connect my web app project to a GitHub repo.
3. Make changes to my web app code - and watch my GitHub repo update too.

## 
- For this, I have to install Git on my EC2 instance first:
```bash
sudo dnf update -y
sudo dnf install git -y
```

- To verify the installation, I run this command:
```bash
git --version
```

- Now I have to create a Github Repo.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/Git%20Repo.png)
## 
- Now to setup a local git repo in my web app folder I'll run this command:
```bash
git init
```

- Then I run this command to link my github repo to my local git. Don't forget to replace [YOUR GITHUB REPO LINK] with the link of your github repo.
```bash
git remote add origin [YOUR GITHUB REPO LINK]
```

- Next, I'll save my changes and push them into GitHub.
```bash
git add . 
git commit -m "Updated index.jsp with new content"
git push -u origin master
```

- Now in the mean time, set up a Github Token doing the following steps:
- Click Settings.


![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/Github%20Token.png)

- Click on Developer Settings.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/Github%20Token%202.png)

- Select Generate new token (classic).

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-github/5.9.png)

- Configure it as:

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
- In the Repository name field, enter `nextwork-devops-cicd`.
- In the Repository description - optional field, enter: `This repository stores packages related to a Java web app created as a part of NextWork's CI/CD Pipeline series`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-145.png)

- Under Public upstream repositories - optional, select the checkbox next to `maven-central-store`.
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

- Under Domain name, enter `nextwork`.

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

- On the Review policy page, in the Policy name field, enter `codeartifact-nextwork-consumer-policy`.
- In the Description - optional field, add a description like: `Provides permissions to read from CodeArtifact. Created as a part of NextWork CICD Pipeline series`.

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

- In the Role name field, enter `EC2-instance-nextwork-cicd`.
- In the Description - optional field, enter: `Allows EC2 instances to access services related to the NextWork CI/CD pipeline series`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-171.png)

- Next, in the review page, click the Create role button to create the IAM role.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-174.png)

- Now, we need to associate this IAM role with your EC2 instance.
- Head back to the EC2 console. And in the Instances tab, select the EC2 which has your application.
- Click on Actions in the menu bar, then select Security, and then Modify IAM role.
- Under IAM role, select the IAM role you just created, `EC2-instance-nextwork-cicd`, from the dropdown menu.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-181.png)

- Select Update IAM role to attach the role to your EC2 instance.

## Re-run export token command

Now that your EC2 instance has the necessary IAM role attached, let's re-run the command to export the CodeArtifact authorization token.

This time, your EC2 instance should be able to retrieve the token, since it has the necessary permissions from the IAM role.

- Head back to your VS Code terminal connected to your EC2 instance.
- Re-run the same export token command from Step 3.
- This command will retrieve a temporary authorization token for CodeArtifact and store it in an environment variable named `CODEARTIFACT_AUTH_TOKEN`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-188.png)



## See Packages in CodeArtifact!

Let's make sure everything is set up correctly by verifying the connection to our CodeArtifact repository from our EC2 instance. We'll configure Maven to use CodeArtifact and then try to compile our web app, which should now download dependencies from CodeArtifact.

This verification is crucial to ensure that our EC2 instance can successfully access and retrieve packages from CodeArtifact, which is a key part of our CI/CD pipeline setup.

- In VS Code, in your left hand file explorer, head to the root directory of your nextwork-web-project.
- Create a new file at the root of your nextwork-web-project directory named `settings.xml`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-192.png)

## What is settings.xml?

settings.xml is like a settings page for Maven - it stores all the settings we saw in Steps 4-6 of the connection window. It tells Maven how to behave across all your projects. In our case, we need a settings.xml file to tell Maven where to find the dependencies and how to get access to the right repositories (e.g. the ones in CodeArtifact).

💡 Extra for Experts: What's xml?
xml is a markup language that lets you structure data and write instructions for a server. It's just like how html is a markup language that lets you structure data and write instructions for a web browser to display a web page.

You might also notice pom.xml, which is a file that was automatically created in your repository's root directory when you set up your web app for the first time.

pom.xml tells Maven the ingredients list (i.e. dependencies) for your web app and how to put them together to build the app. Then, once Maven knows what dependencies to look for, settings.xml tells Maven where to find the dependencies and how to get access to the right repositories (e.g. the ones in CodeArtifact).
##

- Open the `settings.xml` file. If you created a new file, it will be empty.
- In your `settings.xml` file, add the <settings> root tag if it's not already there:
```bash
<settings>
</settings>
```
- Go back to the CodeArtifact connection settings panel.
- From the Connection instructions dialog, copy the XML code snippet from Step 4: Add your server to the list of servers in your `settings.xml`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-200.png)

- Paste the code in the `settings.xml` file, in between the <settings> tags.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-194.png)

- Let's copy the XML code snippet from Step 5: Add a profile containing your repository to your `settings.xml`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-201.png)

- Paste the code snippet you copied right underneath the <servers> tags. Make sure the <profiles> tags are also nested inside the <settings> tags.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-196.png)

- Finally, paste the XML code snippet from Step 6: (Optional) Set a mirror in your `settings.xml`... right underneath the <profiles> tags.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-199.png)

- Save the `settings.xml` file.

## Compile your project and verify the CodeArtifact integration

- Run the Maven compile command, which uses the `settings.xml` file we just configured:
```bash
mvn -s settings.xml compile
```

- You should see messages like Downloading from **nextwork-devops-cicd** telling us that Maven is downloading dependencies from your CodeArtifact repository. This is a good sign that Maven is using CodeArtifact to manage dependencies!
- If the compilation is successful and dependencies are downloaded from CodeArtifact, you'll see a **BUILD SUCCESS** message at the end of the Maven output.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-vscode/6.1.png)

- Now head back to the CodeArtifact console in your browser.
- Close the connection instructions window.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-206.png)

- Click the refresh button in the top right corner of the Packages pane.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codeartifact-updated/screenshot-208.png)

- Now you'll see all the dependencies of your web application.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG17.png)

- These are the dependencies that Maven downloaded from **Maven Central** via **CodeArtifact** when you compiled your project.
- Congrats! This confirms that your CodeArtifact setup is working correctly and that Maven is using it to manage dependencies 💪
## 4. Continuous Integration with CodeBuild

Now in this phase, I am going to create a CodeBuild project to automatically build the code that is in our Github repo.

## What is AWS CodeBuild?

AWS CodeBuild is a fully build tool for your code. It takes your source code, compiles it, runs tests, and packages it up. Engineers love continuous integration tools like CodeBuild because you don't have to manually set up and manage any build servers yourself, and you only pay for the compute time you use for building your projects (instead of entire servers that are idle most of the time). Think of it as a super-efficient, scalable, and managed service that handles all the heavy lifting of building and testing your applications.

Continuous Integration is like having a quality control checkpoint that automatically kicks in whenever anyone on your team makes changes to your code. Instead of waiting until the end of a project to discover that something broke, CI helps you catch and fix issues early and often. CI helps you constantly check that everything still works as expected - running tests, compiling code, and making sure new changes play nicely with the existing codebase.
## 
- In the CodeBuild dashboard, find the left navigation menu.
- Select **Build projects**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-2.png)

Configure Your Build Project
- On the Create build project page, scroll to the Project configuration section.
- Under Project name, enter `nextwork-devops-cicd`.
- Under Project type, make sure **Default project** is selected.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-4.png)

- Scroll down to the Source section.
- Under Source provider, select **GitHub**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-6.png)

- In the Source section, under Credential, you might see the message `You have not connected to GitHub. Manage account credentials.`
- Click on **Manage account credentials**.

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-7.png)

- You will be taken to the Manage default source credential page.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-8.png)

- Ensure GitHub App is selected for Credential type.
- Select **create a new GitHub connection**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-10.png)

- On the Create connection page, under Connection details, enter `nextwork-devops-cicd` as the Connection name.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-12.png)

- Click Connect to GitHub.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-13.png)

- You will be taken to GitHub to authorize the AWS Connector for GitHub application.
- Select your GitHub user account where your repository is located.
- Select Select.
- After authorization on GitHub, you'll get taken back to the AWS console.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-15.png)

- Under GitHub Apps, you'll see that your GitHub username is an option now!.
- Select your GitHub username.
- Click Connect.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-18.png)

- You should get redirected back to CodeBuild's Manage default source credential page after successful connection.
- On the Manage default source credential page, you should see your newly created connection listed.
- Click Save at the bottom of the page.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-21.png)

- Now, back in the Create build project page, in the Source section, you should see a success message in green: **Your account is successfully connected by using an AWS managed GitHub App.**

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-22.png)

- You can now select your GitHub repository `nextwork-devops-webapp` as the source.
- Scroll down to the Primary source webhook events section.
- Untick the Webhook checkbox that says **Rebuild every time a code change is pushed to this repository.** Scroll down to the Environment section.
- Under Compute, for Provisioning model, choose `On-demand`.
- For Environment image, choose `Managed image`.
- For Compute type, choose `EC2`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/lambda-corretto8.png)

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-23.png)

- Under Environment, for Operating system, select `Amazon Linux`.
- For Runtime(s), select `Standard`.
- For Image, choose `aws/codebuild/amazonlinux-x86_64-standard:corretto8`

![App Sreenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-24.png)

- Keep Image version as Always use the latest image for this runtime version.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-26.png)

- Under Service role, select **New service role**.

Now, let's define how CodeBuild will actually build your application using a buildspec.yml file.

- Scroll down to the Buildspec section.
- Under Buildspec format, select Use a **buildspec file**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-28.png)

- Leave Buildspec name as default `buildspec.yml`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-43.png)

- Scroll down to the Batch configuration section.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-29.png)
##

- Scroll down to the Artifacts section. We need to configure where CodeBuild will store the build artifacts.

## What are build artifacts?

Build artifacts are the tangible outputs of your build process. They're what you'll actually deploy to your servers or distribute to users. That's why storing them properly in S3 is so important - they're the whole reason we're running the build in the first place.

For our project, we want our build process to create one build artifact that packages up everything a server could need to host our web app in one neat bundle. This bundle is called a WAR file (which stands for Web Application Archive, or Web Application Resource) and it works just like a zip file - a server will simply "unzip" your WAR file to find a bunch of files and resources (which are also build artifacts, i.e. a WAR file is a build artifact that bundles up other build artifacts) and host your web app straight away. Notice how you haven't been able to view your web app on a web browser so far in this project series - that's because we haven't created and deployed the WAR file yet!

Note: our build process will create a .war file (a packaged Java web application) as the build artifact, but artifacts could be executables, libraries, documentation, or any output your build creates.
##

- For Type, select `Amazon S3`.

## Why store artifacts in Amazon S3?

Your compiled applications, libraries, or any output files from your build need a safe, accessible home after the build finishes. S3 is perfect for this - it's a highly reliable and scalable storage solution that's also in our AWS environment (which makes the artifact easily accessible for deployment later).

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-30.png)

- Let's head to the S3 console. In the AWS Management Console search bar, type S3 and select S3 from the dropdown menu under Services.
- Make sure you're still in the same region where you set up the CodeBuild build project.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-31.png)

- On the Buckets page, click Create bucket.
- In the Create bucket page, under General configuration, for Bucket name, enter `nextwork-devops-cicd-yourname`
- Leave all other settings as default.
- Click Create bucket at the bottom of the page.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG19.png)

- In your CodeBuild project, head back to the Artifacts section.
- For Type, select `Amazon S3`.
- For Bucket name, choose your newly created bucket `nextwork-devops-cicd-yourname` from the dropdown.
- In Name, enter `nextwork-devops-cicd-artifact`. This names our artifact, so it's easy to spot it in the S3 bucket.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-45.png)

- For Artifacts packaging, select `Zip`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-47.png)

- Scroll down to the Logs section.
- Make sure **CloudWatch logs** is checked.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-48.png)

- In Group name, enter `/aws/codebuild/nextwork-devops-cicd`

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-49.png)

- Scroll to the bottom of the page and click **Create build project**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-50.png)

- Create a `buildspec.yml` file in your web app.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-66.png)

- Paste the following code for `buildspec.yml`:
```bash
version: 0.2

phases:
  install:
    runtime-versions:
      java: corretto8
  pre_build:
    commands:
      - echo Initializing environment
      - export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain nextwork --domain-owner 123456789012 --region us-east-2 --query authorizationToken --output text`

  build:
    commands:
      - echo Build started on `date`
      - mvn -s settings.xml compile
  post_build:
    commands:
      - echo Build completed on `date`
      - mvn -s settings.xml package
artifacts:
  files:
    - target/nextwork-web-project.war
  discard-paths: no
```

## What's inside buildspec.yml?

This buildspec.yml file is like a recipe for how to build your Java web app. Let's break it down into simpler terms:

version: 0.2: This just tells AWS which version of the buildspec format we're using.

phases: Think of these as the different stages your build goes through: install is the "prep work" phase - here, we're telling CodeBuild to use Java 8. pre_build are tasks to do before the main building starts. Here, we're grabbing a security token so we can access our dependencies. build is where the actual building happens. We're using Maven (a popular Java build tool) to compile our code. post_build are the finishing touches after the main build is done. Here, we're packaging everything into a WAR file (a format for web applications).

artifacts tells CodeBuild which files to save as the output of the build. In our case, we want that WAR file we created during the post_build phase.
##
In the `buildspec.yml` file:
- Replace the placeholder **AWS Account ID 123456789012** with your actual **AWS Account ID**.
- Check that the region code is correct! Update the region section from **--region us-east-2** to the AWS region you're using.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-68.png)

- Now, we need to commit and push the `buildspec.yml` file to your GitHub repository so CodeBuild can access it.
```bash
git add .
git commit -m "Adding buildspec.yml file"
git push
```

Now we need to grant CodeBuild's IAM role the permission to access CodeArtifact.
- Head to the IAM console.
- In the IAM console, select Roles in the left navigation menu.
- In the roles search bar, type `codebuild` to filter the roles.
- Select the role that starts with `codebuild-nextwork-devops-cicd-service-role`. This is the new service role that CodeBuild created when we set up our build project.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-86.png)

- Select your CodeBuild service role.
- Click on the **Add permissions** button.
- Choose **Attach policies**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-88.png)

- In the Filter policies search bar, type `codeartifact-nextwork-consumer-policy`
- Check the checkbox next to the policy named `codeartifact-nextwork-consumer-policy`

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-89.png)

- After selecting the policy, click the **Add permissions** button.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-92.png)
##
- Navigate to your newly created CodeBuild project **nextwork-devops-cicd**.
- Click the **Start build** button.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG20.png)

- You should see the build status change to **In progress**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-55.png)

- The build status should now be Succeeded with a green checkmark, indicating a successful CI pipeline run!

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codebuild-updated/screenshot-97.png)
##

- Now head to the S3 console.
- Select the bucket you created earlier.
- You should now see the artifact **nextwork-devops-cicd-artifact.zip** listed in your bucket.

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/IMG23.png)


## Launch EC2 with CloudFormation

Let's start our deployment by setting up the deployment infrastructure. We'll use CloudFormation to launch an EC2 instance and its networking resources.

- Select **Create stack**.
- Select **With new resources (standard)** from the dropdown menu.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-2.png)

- Select Template is ready.
- Select Upload a template file.
- Select Choose file.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-5.png)

- Upload the following CloudFormation template: `nextworkwebapp.yaml`

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/YAML%20File.png)

- Verify the file `nextworkwebapp.yaml` is uploaded and select Next.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-6.png)

- Select Next
- Enter `NextWorkCodeDeployEC2Stack` as the Stack name.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-7.png)

- Next, we'll need to add our IP address to the template.
- Head to https://checkip.amazonaws.com/ and copy your IP address.
- Paste your IP address into the MyIP parameter field and add /32 at the end.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-9.png)

- Select Next.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-10.png)

Configure Stack Options
- In Configure stack options, under Stack failure options, select **Roll back all stack resources**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-11.png)

- Next, select **Delete all newly created resources**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-12.png)

- Scroll down to Capabilities and check the box **I acknowledge that AWS CloudFormation might create IAM resources**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-13.png)

- Select Next.

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-14.png)

- Review and Submit
- Select Submit.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-19.png)

- CloudFormation is now launching the stack in the background! This process will create the EC2 instance and networking resources in the background.
- Let's check out the Resources tab.
- You can see a list of the resources being created!

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-21.png)

- Wait for the stack's status to become **CREATE_COMPLETE**.




## 5. Deploy a Web App with CodeDeploy

To start deploying our application, we need to prepare a set of scripts and configuration files for CodeDeploy. It's like we need to write a set of instructions for CodeDeploy to follow - otherwise, it wouldn't know how to deploy our application!

- In your IDE, create a new folder at the root of your project directory.
- Name the folder `scripts`
- Inside the scripts folder, create a new file named `install_dependencies.sh`
- Add the following content to `install_dependencies.sh`:
```bash
#!/bin/bash
sudo yum install tomcat -y
sudo yum -y install httpd
sudo cat << EOF > /etc/httpd/conf.d/tomcat_manager.conf
<VirtualHost *:80>
  ServerAdmin root@localhost
  ServerName app.nextwork.com
  DefaultType text/html
  ProxyRequests off
  ProxyPreserveHost On
  ProxyPass / http://localhost:8080/nextwork-web-project/
  ProxyPassReverse / http://localhost:8080/nextwork-web-project/
</VirtualHost>
EOF
```

- Now create another file called `start_server.sh`
- Add the following content to `start_server.sh`:
```bash
#!/bin/bash
sudo systemctl start tomcat.service
sudo systemctl enable tomcat.service
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
```

- Now create a new file named `stop_server.sh`
- Add the following content to `stop_server.sh`:
```bash
#!/bin/bash
isExistApp="$(pgrep httpd)"
if [[ -n $isExistApp ]]; then
sudo systemctl stop httpd.service
fi
isExistApp="$(pgrep tomcat)"
if [[ -n $isExistApp ]]; then
sudo systemctl stop tomcat.service
fi
```

- Check that you have `install_dependencies.sh`, `start_server.sh`, and `stop_server.sh` inside the **scripts** folder.
##

- Create a new file, but this time at the **root** of your project.
- Make sure this file is NOT inside the **scripts** folder!
- Name the file `appspec.yml`
- Add the following content to `appspec.yml`:
```bash
version: 0.0
os: linux
files:
  - source: /target/nextwork-web-project.war
    destination: /usr/share/tomcat/webapps/
hooks:
  BeforeInstall:
    - location: scripts/install_dependencies.sh
      timeout: 300
      runas: root
  ApplicationStart:
    - location: scripts/start_server.sh
      timeout: 300
      runas: root
  ApplicationStop:
    - location: scripts/stop_server.sh
      timeout: 300
      runas: root
```

Update `buildspec.yml` File
- Open `buildspec.yml` and modify the artifacts section to include `appspec.yml` and the scripts folder:
```bash
artifacts:
  files:
    - target/nextwork-web-project.war
    - appspec.yml
    - scripts/**/*
  discard-paths: no
```

- Now from the terminal push these changes.
```bash
git add .
git commit -m "Adding CodeDeploy files"
git push
```

## Set Up CodeDeploy

- Head to the CodeDeploy console.
- Select Applications in the left hand navigation menu.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-47.png)

- Select Create application.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-48.png)

## What is a CodeDeploy application?

A CodeDeploy application is like the main folder for your deployment project. It doesn't do much on its own, but it helps you organize everything related to deploying one application.


In more technical, AWS terms, a CodeDeploy application is a namespace or container that groups deployment configurations, deployment groups, and revisions for a specific application. Having separate CodeDeploy applications helps you manage multiple applications without mixing up their deployment resources.

- Enter `nextwork-devops-cicd` as the Application name.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-49.png)

- Choose `EC2/On-premises` as the Compute platform.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-50.png)

- That's it! Select **Create application**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-51.png)

- Wait for the success message that the application nextwork-devops-cicd is created.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-52.png)

- Select **Create deployment group**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-53.png)

- Enter `nextwork-devops-cicd-deploymentgroup` as the Deployment group name.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-54.png)
##

Now we have to pause here and go to IAM console to create a service role.
- Head to the IAM console.
- In the IAM console, select Roles from the left hand navigation bar.
- Select **Create role**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-58.png)

- Choose `AWS service` as the trusted entity type.
- Choose `CodeDeploy` as the service and select CodeDeploy as the use case.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-60.png)

- Select Next.
- You'll notice the `AWSCodeDeployRole` default policy is suggested already - nice! That's all we need.

 ![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-62.png)

- Select Next.
- Enter `NextWorkCodeDeployRole` as the Role name.
- Add a description to help you remember why you created this role.
```bash
Allows CodeDeploy to call AWS services such as Auto Scaling on your behalf. Created as a part of NextWork's Cl/CD Pipeline series.
```

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-64.png)

- Review the Permissions policies and make sure **AWSCodeDeployRole** is attached.

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-65.png)

- Select **Create role**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-66.png)
##

## Select This Service Role in CodeDeploy

- Head back to the CodeDeploy deployment group configuration tab.
- Select the newly created `NextWorkCodeDeployRole` as the Service role.
- Choose `In-place` as the Deployment type.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-69.png)


- Under Environment configuration, select `Amazon EC2 instances`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-71.png)

- In Tag group 1, enter `role` as the `Key`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-72.png)

- Enter `webserver` as the `Value`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-73.png)

- Check the line below your tag settings - you might notice that **1 unique matched instance is found**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-74.png)

- Click **Click here for details** to view the matched instance.
- You'll see an EC2 instance called `NextWorkCodeDeployEC2Stack::WebServer` - that's the EC2 instance we launched from our CloudFormation template. This confirms to us that the web app will be deployed onto that instance instance.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-76.png)

Configure Agent and Deployment Settings
- Now let's head back to your **CodeDeploy Deployment group** set up.
- Under Agent configuration with AWS Systems Manager, select **Now and schedule updates** and Basic scheduler with **14 Days**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-77.png)

- In Deployment settings, keep the default `CodeDeployDefault.AllAtOnce`

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-78.png)

- Deselect **Enable load balancing**.
- Select **Create deployment group**

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-80.png)

- In the deployment group details page, select **Create deployment**.
- Under Revision type, make sure **My application is stored in Amazon S3** is selected. That's because our deployment artifact is inside an S3 bucket!

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-82.png)

- Head back to your S3 bucket called `nextwork-devops-cicd`.
- Click into the `nextwork-devops-cicd-artifact` build artifact.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-83.png)

- Copy the file's **S3 URI**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-85.png)

- Paste the S3 URI into the Revision location field in CodeDeploy.
- Select `.zip` as the Revision file type.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-88.png)

- Next, we'll leave **Additional deployment behavior** settings as **default**.
- Select **Create deployment**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-90.png)

- CodeDeploy kicks off a deployment of your web app.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-91.png)

- Scroll down to Deployment lifecycle events and monitor the events by clicking View events.
- See the lifecycle events progressing, such as **BeforeInstall**, **ApplicationStart**, etc. These are the events you defined in **appspec.yml**!

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-92.png)

- Now head back to your CodeBuild build project, and rebuild your project.
- Once your second build is a success, return to CodeDeploy and retry the deployment.
- Wait until the **deployment status** says **Success**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-92.png)

- Select the **Instance ID** in the Deployment lifecycle events panel. This takes you to the deployment EC2 instance you launched with CloudFormation.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-93.png)

- Get the Public IPv4 DNS of your EC2 instance from the EC2 console.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-94.png)

- Open the Public IPv4 DNS in a web browser.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codedeploy-updated/screenshot-96.png)

You've successfully automated a web app's deployment to EC2 using AWS CodeDeploy!
## 6. Build a CI/CD Pipeline with AWS CodePipeline

Now I am going to set up a CI/CD pipeline with AWS CodePipeline for Continous Integration and Continuous Deployment automatically.

## What is AWS CodePipeline? Why are we using it?

With CodePipeline, you can create a workflow that automatically moves your code changes through the build and deployment stage. In our case, you'll see how a new push to your GitHub repository automtically triggers a build in CodeBuild (continuous integration), and a then a deployment in CodeDeploy (continuous deployment)!

Using CodePipeline makes sure your deployments are consistent, reliable and happen automatically whenever you update your code - with less risk of human errors! It saves you time too.
##
- Head to the CodePipeline console.
- In the CodePipeline dashboard, Select Create pipeline.
- Select **Build custom pipeline**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-2.png)

- Click Next.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-3.png)

- Name your pipeline `nextwork-devops-cicd`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-4.png)

- Under Execution mode, select **Superseded**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-6.png)

- Under Service role, select **New service role**. Keep the **default** role name.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-7.png)

- Expand Advanced settings.
- Leave the **default** settings for **Artifact store**, **Encryption key**, and **Variables**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-9.png)

- Click Next.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-10.png)

- In the Source provider dropdown, select **GitHub (via GitHub App)**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-11.png)

- Under Connection, select your existing GitHub connection

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-12.png)

- Under Repository name, select `nextwork-web-project`
- Under Default branch, select `master`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-14.png)

- Under Output artifact format, leave it as **CodePipeline default**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-15.png)

- Make sure that Webhook events is checked under Detect change events.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-16.png)

- Click Next.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-17.png)

- In the Build provider dropdown, select **AWS CodeBuild** from Other build providers.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-18.png)

- Under Project name, select your existing CodeBuild project

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-19.png)

- In the Project name dropdown, search for and select `nextwork-devops-cicd`.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-20.png)

- Leave the **default** settings for **Environment variables**, **Build type**, and **Region**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-21.png)

- Under Input artifacts, **SourceArtifact** should be selected by default.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-22.png)

- Click Next.
- On the Add test stage page, click **Skip test stage**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-24.png)

- In the Deploy provider dropdown, select **AWS CodeDeploy**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-25.png)

- Under **Input artifacts**, **BuildArtifact** should be selected by **default**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-27.png)

- Under Application name, select your existing CodeDeploy application

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-28.png)

- Under Deployment group, select your existing CodeDeploy deployment group

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-29.png)

- Check the box for **Configure automatic rollback on stage failure**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-31.png)

- Click Next.
- On the Review page, take a moment to review all the settings you've configured for your pipeline.
- Once you've reviewed all the settings and confirmed they are correct, click **Create pipeline**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-38.png)

- After clicking Create pipeline, you will be taken to the pipeline details page.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-39.png)

- CodePipeline automatically starts executing the pipeline as soon as it's created.
- You can see the progress of each stage in the pipeline diagram. The stages will transition from grey to **blue (in progress)** to **green (success)** as the pipeline executes.

## Test Your Pipeline

- Open the `index.jsp` file located in src/main/webapp/ and make some changes.
- Save the `index.jsp` file.
- Open your terminal and navigate to your local git repository for the web app.
- Commit and push the changes to your GitHub repository using the following commands:
```bash
git add .
git commit -m "Update index.jsp with a new line to test CodePipeline"
git push origin master
```
- Go back to the CodePipeline console and watch your pipeline react to the code change.
- You should see a new execution starting automatically after you push the changes to GitHub.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-45.png)

- Wait for the Build and Deploy stages to complete successfully (turn green) in the CodePipeline console.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-devops-codepipeline-updated/screenshot-50.png)

- You should see your web application with the new line(s) you added:

![App Screenshot](https://raw.githubusercontent.com/UXHERI/Cloud-Projects/refs/heads/main/CICD-Pipeline-With-AWS/Images/Final.png)

- The CI/CD pipeline is now automatically building and deploying my web application whenever I push changes to GitHub.

So that was a detailed project on how to build CI/CD Pipeline on AWS using Github as the source.
