
# Build a Three-Tier Web Application on AWS

In this project, I am going to show you you can create a three-tier web application on AWS.

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-compute-threetier/architecture-complete.png)

> [!IMPORTANT]
> Three-tier architecture is a way to organize web applications. It divides an app into three tiers to make your application easier to manage and scale.
> 1. Presentation Tier: Website Delivery with CloudFront
> 2. Logic Tier: APIs with Lambda + API Gateway
> 3. Data Tier: Fetch Data with AWS Lambda


## Step-by-Step Project Guide:

- Create an S3 Bucket for Website's files.
- Creating a CloudFront Distribution.
- Creating a Lambda Function.
- Set Up API Gateway.
- Creating a DynamoDB Table.
- Integrating the Three Tiers.
- Vaidate a Fully Functioning Web App

## 1. Create an S3 Bucket for Website's files 

In the first step, we will create our S3 bucket to store our web app's files in that.

- In the **AWS Console**, head to `S3` console.
- Click **Create bucket**.
- Enter a unique **Bucket name**, like `nextwork-three-tier-[your-name]` (_Replace your-name with your actual name_).

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/1.png?raw=true)

- Leave all other settings as default.
- Select **Create bucket**.
- Go to this [Github Folder](https://github.com/UXHERI/Cloud-Projects/tree/main/Three-Tier-Web-App-on-AWS/Web-App-Files), and download these three files.

![App SCreenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/39.png?raw=true)

- Head to the **Downloads** folder in your local computer. Let's see if you can find the files you've downloaded.
- Open **index.html** in your browser.
- You will see a **sample page** like this.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-networks-cloudfront/processed_image_2.png)

- Head back to the **S3 console**.
- Select **Upload**.
- Select **Add files**.
- Select the three website files in your **Downloads** folder.
- Select **Upload**.
- Upload success!

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/6.png?raw=true)

## 2. Create a CloudFront Distribution

In this second step, we will create a **CloudFront Distribution** for faster delivery of our website content to users in different regions.

- Head to the `CloudFront` console.
- Select **Create a CloudFront distribution**.
- Under **Origin domain**, select your S3 bucket from the dropdown list. Your S3 bucket's name should start with `nextwork-three-tier`.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/8.png?raw=true)

- For the **Origin's Name**, enter `nextwork-three-tier S3 bucket`.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/9.png?raw=true)

- For **Origin accesss**, change the setting from **Public** to **Origin access control settings (recommended)**.
- Under the new **Origin access control** heading, select **Create new OAC**.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/12.png?raw=true)

- Keep the **default** settings for your OAC.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/11.png?raw=true)


- Select **Create**.
- A popup appears under the **Origin access control** you've just created.
- Under **Web Application Firewall (WAF)** panel, select **Do not enable security protections**.

![SS](https://learn.nextwork.org/projects/static/aws-networks-cloudfront/processed_image_16.png)

- Under the **Settings** panel, for **Default root object**, enter `index.html`.

![SS](https://learn.nextwork.org/projects/static/aws-networks-cloudfront/processed_image_14.png)

- Leave all other settings as default.
- Select **Create distribution**.

## Update your S3 bucket's settings

Before we can wrap up this presentation tier, we're going to make sure we've updated the policy in our S3 bucket!

- Select **Copy policy** on the banner that warns you about updating S3.

![SS](https://learn.nextwork.org/projects/static/aws-compute-threetier/processed_image_16.png)

- Next, select the shortcut in the banner. It lets you go straight to your S3 bucket's **Permissions** tab.

![SS](https://learn.nextwork.org/projects/static/aws-compute-threetier/processed_image_15.png)

- In your S3 bucket's **Permissions** page, scroll to the **Bucket policy** section.
- Select **Edit**.
- Paste the policy that you copied into the **policy editor**.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/13.png?raw=true)

- Select **Save changes**.

## Verify Your CloudFront Distribution

Now, let's check if our website is live!

- Head back into your `CloudFront` console.
- Copy the distribution domain name. This is the URL that CloudFront will use to serve your website.

![SS](https://learn.nextwork.org/projects/static/aws-networks-cloudfront/processed_image_18.png)

- Paste the **domain name** into your web browser.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/14.png?raw=true)

_Congrats on distributing your website over CloudFront. This ticks off the presentation tier, which is all about the interface that your users and see and interact with._

## 3. Creating a Lambda Function.

Let's create a **Lambda function**. This function will fetch data from a database and return it to the user. This is a very common use case in web apps.

- Head to the `Lambda` console.
- Click **Create function**.
- Select **Author from scratch**.
- For **Function name**, enter `RetrieveUserData`.
- For **Runtime**, select a runtime using **Node.js**.
- For **Architecture**, select **x86_64**.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/16.png?raw=true)

- Select **Create function**.
- Scroll down to the **Code source** panel.
- Copy and paste the following code into the code editor, replacing `YOUR_REGION` with your actual AWS region (e.g., 'us-east-1'):

```javascript
// Import individual components from the DynamoDB client package
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

const ddbClient = new DynamoDBClient({ region: 'YOUR_REGION' });
const ddb = DynamoDBDocumentClient.from(ddbClient);

async function handler(event) {
    const userId = event.queryStringParameters.userId;
    const params = {
        TableName: 'UserData',
        Key: { userId }
    };

    try {
        const command = new GetCommand(params);
        const { Item } = await ddb.send(command);
        if (Item) {
            return {
                statusCode: 200,
                body: JSON.stringify(Item),
                headers: {'Content-Type': 'application/json'}
            };
        } else {
            return {
                statusCode: 404,
                body: JSON.stringify({ message: "No user data found" }),
                headers: {'Content-Type': 'application/json'}
            };
        }
    } catch (err) {
        console.error("Unable to retrieve data:", err);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Failed to retrieve user data" }),
            headers: {'Content-Type': 'application/json'}
        };
    }
}

export { handler };
```

- Select **Deploy**.

_You have successfully created and deployed the **Lambda** function for this project!_

## 4. Set Up API Gateway

Now that we have our Lambda function ready, we need a way to access it. This is where **API Gateway** comes in.

- In the **AWS Management Console**, head to the `API Gateway` console.
- Scroll down the list of available API types.
- Find **REST API**.
- Select **Build**.
- Under API details, select **New API**.
- For **API name**, enter `UserRequestAPI`.
- For **API endpoint type**, select **Regional**.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/18.png?raw=true)

- Select **Create API**.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/19.png?raw=true)

- Under **Resources**, select **Create resource**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-api/processed_image_14.png)

- For **Resource name**, enter `users`.

![SS](https://learn.nextwork.org/projects/static/aws-compute-api/processed_image_15.png)

- Select **Create resource**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-api/processed_image_16.png)

- Select the **/users** resource.
- In the **Methods** panel, select **Create method**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-api/processed_image_17.png)

- Select **GET** from the **Method type** dropdown.

![SS](https://learn.nextwork.org/projects/static/aws-compute-api/processed_image_18.png)

- Select **Lambda Function** for the **Integration type**.
- Switch on **Lambda proxy integration**.
- For the **Lambda function**, make sure the default region selected is where you've created your function.
- Select your `RetrieveUserData` function.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/21.png?raw=true)

- Select **Create method**.
_Method created!_

![SS](https://learn.nextwork.org/projects/static/aws-compute-api/processed_image_22.png)

- Select **Deploy API**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-api/processed_image_23.png)

- For **Stage**, select **New stage**.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/22.png?raw=true)

- Select **Deploy**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-api/processed_image_27.png)

## 5. Creating a DynamoDB Table.

Now we will create the Data Tier that is **DynamoDB table** and access it through the Lambda function and API Gateway.

- Head to the `DynamoDB` console.
- Select **Create table**.
- For **Table name**, enter `UserData`.
- For **Partition key**, enter `userId`.
- Select **String** as the data type for the partition key.
- Leave the default settings for the rest of the options.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/23.png?raw=true)

- Select **Create table**.
- Once the table status changes to **Active**, select your `UserData` table.
- Select **Explore table items**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-lambda/processed_image_2.png)

- At the **Items returned** panel, select **Create item**.
- Select **Switch to JSON view**.
- Switch off **View DynamoDB JSON**.
- Paste the following JSON into the editor:

```json
{
  "userId": "1",
  "name": "Test User",
  "email": "test@example.com"
}
```

- Select **Create item**.
- Verify that the item was created successfully. You should see it listed in the **Items returned** tab.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/24.png?raw=true)

- Head back to your `Lambda` console.
- Switch to the **Configuration** tab in your Lambda function.

![SS](https://learn.nextwork.org/projects/static/aws-compute-lambda/processed_image_18.png)

- Select **Permissions**.
- Select the execution role name (it will look something like `RetrieveUserData-role-xxxxxxxx`).

![SS](https://learn.nextwork.org/projects/static/aws-compute-lambda/processed_image_19.png)

- This shortcut will take you to the IAM console, with your Lambda function readily open.

![SS](https://learn.nextwork.org/projects/static/aws-compute-lambda/processed_image_20.png)

- Select **Add permissions**.
- Select **Attach policies**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-lambda/processed_image_22.png)

- Type `DynamoDB` in the search bar.
- Select **AmazonDynamoDBReadOnlyAccess** as the permission policy we'll use.

![SS](https://learn.nextwork.org/projects/static/aws-compute-lambda/processed_image_23.png)

- Select **Add permissions**.

## 6. Integrating the Three Tiers

We've built all three tiers of our application! Now, it's time to connect them. We'll update our `index.html` file to make a request to our API Gateway endpoint and display the returned data.

- Head back into your `API Gateway` console.
- Copy your prod stage API's **Invoke URL**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-threetier/processed_image_9.png)

- Append `/users?userId=1` to the end of the URL you've copied.
- Run the edited URL in your web browser.
- You can see your table's data getting returned by the API.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/31.png?raw=true)

_That's the logic and data tier's integration verified ✅_

## Verify the distributed website

- Find your **distributed site's URL** in the **CloudFront** console again.
- Open the URL in your browser.
- Try entering `1` in the **userId** field and selecting **Get User Data**.
- Do you see data returned to you?

_No, it did not returned any data because we have not make some chanes in the `script.js` file._

- Open your local computer's **Downloads** folder.
- Open `script.js` in a code/text editor.
- Now copy your `prod` stage API's **Invoke URL**.
- Paste this in **script.js**, making sure you're replacing `[YOUR-PROD-API-URL]` in the script.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/40.png?raw=true)

- Save your changes.

## Upload the new `script.js` to S3 Bucket

- Head back to the `S3` console.
- Select **Upload**.
- Select **Add files**.
- Select the updated `script.js` in your **Downloads** folder.
- Select **Upload**.

## Configure CORS on API Gateway

- Head back to the `API Gateway` console in your AWS account.
- Navigate to the **Resources** tab.
- Select the **/users** resource.
- Select **Enable CORS**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-threetier/processed_image_10.png)

- In the CORS configuration, check both **GET** and **OPTIONS** under **Access-Control-Allow-Methods**.

![SS](https://learn.nextwork.org/projects/static/aws-compute-threetier/processed_image_11.png)

- Enter your **CloudFront distribution domain name** as the **Access-Control-Allow-Origin value**. This will allow requests from your CloudFront domain to your API.
- Select **Save**.
- Select **Deploy API**.
- Choose your deployment stage i.e. **prod**.
- Click **Deploy** to update the stage.

## Add CORS Headers in Your Lambda Function

This means the **CORS headers** must be added directly in your **Lambda** function response, not within **API Gateway**.

- Update your Lambda function code to include the **Access-Control-Allow-Origin** header in the response:

```javascript
// Import individual components from the DynamoDB client package
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

const ddbClient = new DynamoDBClient({ region: 'YOUR_REGION' });
const ddb = DynamoDBDocumentClient.from(ddbClient);

async function handler(event) {
    const userId = event.queryStringParameters.userId;
    const params = {
        TableName: 'UserData',
        Key: { userId }
    };

    try {
        const command = new GetCommand(params);
        const { Item } = await ddb.send(command);

        if (Item) {
            return {
                statusCode: 200,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*' // Allow CORS for all origins, replace '*' with specific domain in production
                },
                body: JSON.stringify(Item)
            };
        } else {
            return {
                statusCode: 404,
                headers: {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                body: JSON.stringify({ message: "No user data found" })
            };
        }
    } catch (err) {
        console.error("Unable to retrieve data:", err);
        return {
            statusCode: 500,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: JSON.stringify({ message: "Failed to retrieve user data" })
        };
    }
}

export { handler };
```

- Updated `YOUR_REGION` to your region's code.
- For security best practice, replace `*` with your CloudFront domain name. Keeping `Access-Control-Allow-Origin` means you're allowing everyone to use your API, but we should restrict access to just your CloudFront distribution.

![SS](https://learn.nextwork.org/projects/static/aws-compute-threetier/processed_image_4.png)

- Select **Deploy** to deploy your updated function.

## Invalidate the Old Configurations

Now we have to invalidate the old configurations of our **CloudFront Distribution** so that it can serve the website with new configurations.

- Go to your `CloudFront` console.
- Select your **CloudFront Distribution**.
- Click on **Invalidations**.
- Click **Create invalidation**.
- In **Add object paths**, add `/*`.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/38.png?raw=true)

- Click **Create invalidation**.

## 7. Vaidate a Fully Functioning Web App

In this last step, we will validate and verify that this web app is fully functional and working correctly.

- Copy your **CloudFront domain name**.
- Paste it into the web browser.
- Enter `1` and click **Get User Data**.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/32.png?raw=true)

_Now you are retrieving your DynamoDB data successfully!_

## Add and Retrieve a New User Data

- Head to your **DynamoDB table**.
- Select **Explore table items**.
- At the **Items returned** panel, select **Create item**.
- Now add any data as you like!

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/33.png?raw=true)

- Select **Create item**.
- Now open the **Invoke URL** of your **prod** stage in a web browser and append `/users?userId=2` at the end. (Make sure your userId in the Invoke URL is same as of in DynamoDB table)

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/35.png?raw=true)

-  To test it from **CloudFront** enter `2` and click **Get User Data**.

![SS](https://github.com/UXHERI/Cloud-Projects/blob/main/Three-Tier-Web-App-on-AWS/Images/36.png?raw=true)

_Congrats! You have successfully built and tested a three-tier web application on AWS ✅. Now you can add and retrieve any data from DynamoDB table using the CloudFront distributed website._
