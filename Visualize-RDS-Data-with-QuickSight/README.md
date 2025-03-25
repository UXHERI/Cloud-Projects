
# Visualize a Relational Database with AWS QuickSight

In this beginner friendly project we'll create our own **relational database (Amazon RDS)**, populate it with data, and connect it to **QuickSight**, a tool in AWS for visualizing data.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-databases-rds/architecture-diagram.png)

## Step-by-Step Project Guide:

- Create a Relational Database.
- Launch an EC2 Instance.
- Connect to our Database via EC2
- Create Database Tables and Load Data.
- Connect RDS to QuickSight.
- Visualize RDS Data.

## 1. Create a Relational Database

In this step, we are going to create a relational database in AWS which will be a MySQL Database.

- Head to your **AWS console** and search for `RDS` in search bar at the top of the screen.
- In the left navigation bar, select **Databases**.
- In the **Database** section, select **Create Database**.
- On the **Create database** page, choose **Standard Create**.
- In the **Configuration** section, make the following changes:
    - For **Engine type**, choose **MySQL**.
    - For **Templates**, choose **Production**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/1.png?raw=true)

- In the **Availability and durability** section, choose **Single-AZ DB instance deployment (1 instance)**.
![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/2.png?raw=true)

- For **DB instance identifier**, type `QuickSightDatabase`.
- For **Master username**, enter `admin`.
- In the **Credentials management** section, select **Self managed**.
- For **Master password**, type a unique password, and confirm password.
_Make sure you save your database login details somewhere safe! You'll need them later on._

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/3.png?raw=true)

- In the **Instance configuration** section, select **Bustable classes (includes t classes)** and choose **db.t3.micro** as the **Instance type**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/4.png?raw=true)

- Leave the rest as the default settings and select choose **Create database**.

_We have successfully created our relational database._

## 2. Launch an EC2 instance

In this step, I we are launching an EC2 instance to access our database from.

- Head to the **AWS console** - search for `EC2` in the search bar at the top of screen.
- Select **Instances** at the left hand navigation bar.
- Select **Launch instances**.
- Name your EC2 instance `Lab EC2`.
- For the **Amazon Machine Image**, select **Amazon Linux 2023 AMI**.
- For the **Instance type**, select **t2.micro**.
- For the **Key pair (login)** panel, select **Proceed without a key pair (not recommended)**.
- Keep rest of the settings as **default**.
- Click **Launch instance**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/13.png?raw=true)

## 3. Connect to Database via EC2

In this step, we will be going to access our database from our EC2 instance that we just created.

- Select your **Lab EC2** instance.
- Click **Connect**.
- Choose **Session Manager**.
- Type these commands to install MySQL on your EC2 instance.

```bash
dnf -y localinstall https://dev.mysql.com/get/mysql180-community-release-e19-4.noarch.rpm
```
_This command will install MySQL community on your EC2 instance._

```bash
dnf -y install mysql mysql-community-client
```
_This will install MySQL community client._

```bash
dnf -y install mysql mysql-community-server
```
_This will install MySQL Community Server._

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/6.png?raw=true)

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/7.png?raw=true)

- Now run this command to connect to your Database.

```bash
mysql -h <RDS-Endpoint> -P 3306 -u admin --password='<Your Password>'
```

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/8.png?raw=true)

## 4. Create Database Tables and Load Data.

Now we will populate our database with some data to later on visualize it.

- Run this command to make a database.

```sql
CREATE DATABASE QuickSightDatabase:
```

- To see the database that you created run this command.

```sql
SHOW DATABASES:
```

- Now create a table in your database.
```sql
CREATE TABLE newhire(
empno INT PRIMARY KEY,
ename VARCHAR(10),
job VARCHAR(9),
manager INT NULL,
hiredate DATETIME,
salary NUMERIC(7,2),
comm NUMERIC(7,2) NULL,
department INT)
```

- To see the table that you created, run this command.

```sql
SHOW TABLES:
```

- To view the contents of this table run this command.

```sql
SELECT * FROM newhire;
```

- Now let's populate our new table by running another query.

```sql
INSERT INTO newhire (empno, ename, job, manager, hiredate, salary, comm, department) VALUES
(1, 'JOHNSON', 'ADMIN', 6, '1990-12-17', 18000, NULL, 4),
(2, 'HARDING', 'MANAGER', 9, '1998-02-02', 52000, 300, 3),
(3, 'TAFT', 'SALES I', 2, '1996-01-02', 25000, 500, 3),
(4, 'HOOVER', 'SALES I', 2, '1990-04-02', 27000, NULL, 3),
(5, 'LINCOLN', 'TECH', 6, '1994-06-23', 22500, 1400, 4),
(6, 'GARFIELD', 'MANAGER', 9, '1993-05-01', 54000, NULL, 4),
(7, 'POLK', 'TECH', 6, '1997-09-22', 25000, NULL, 4),
(8, 'GRANT', 'ENGINEER', 10, '1997-03-30', 32000, NULL, 2),
(9, 'JACKSON', 'CEO', NULL, '1990-01-01', 75000, NULL, 4),
(10, 'FILLMORE', 'MANAGER', 9, '1994-08-09', 56000, NULL, 2),
(11, 'ADAMS', 'ENGINEER', 10, '1996-03-15', 34000, NULL, 2),
(12, 'WASHINGTON', 'ADMIN', 6, '1998-04-16', 18000, NULL, 4),
(13, 'MONROE', 'ENGINEER', 10, '2000-12-03', 30000, NULL, 2),
(14, 'ROOSEVELT', 'CPA', 9, '1995-10-12', 35000, NULL, 1);
```

- Now to view the contents of this table run this command again.

```sql
SELECT * FROM newhire;
```

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/11.png?raw=true)

- Now we will create a second table.

```sql
CREATE TABLE department(
deptno INT NOT NULL,
dname VARCHAR(14),
loc VARCHAR(13));
```
- Now let's populate this second table.

```sql
INSERT INTO department (deptno, dname, loc) VALUES 
(1, 'ACCOUNTING', 'ST LOUIS'),
(2, 'RESEARCH', 'NEW YORK'),
(3, 'SALES', 'ATLANTA'),
(4, 'OPERATIONS', 'SEATTLE');
```

- To view contents of your second table, run this command.

```sql
SELECT * FROM department;
```

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/12.png?raw=true)

## 5. Connect RDS to QuickSight

In this step, we are going to connect our RDS database with AWS QuickSight for visualizing our data.

- Navigate back into your RDS instance from the **RDS console** in AWS.
- Open your RDS instance.
- Under **Connectivity & security**, select the link in **VPC security groups** to open the related security group.
- Open the security group by selecting the **Security group ID**.
- Select **Edit inbound rules** to add a new rule with the following details:
    - Type: **All Traffic**
    - Source: **Custom**, then `0.0.0.0/0` in the next box.

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-databases-rds/high-step5.1.png)

- Select **Save rules**.
- Navigate to QuickSight by searching `Amazon QuickSight` in the search bar at the top of your **AWS console**.
- If this is your first time using **QuickSight**, follow the sign-up flow;
    - PLEASE make sure to **untick** the offer to upgrade with the optional add-on **Add Paginated Reports**. No getting charged today!
    - Make sure you select the same Region as the one you've been doing this project in.
- Once you're in QuickSight, select **Datasets** from the left menu.
- In the top right of the screen, select **New dataset**.

![App Screenshot](https://learn.nextwork.org/projects/static/aws-databases-rds/high-step5.2.png)

- Select **RDS**.
- Fill out the following values:
    - **Data source name**: `RDS_Public_Database`
    - **Instance ID**: select your database from the drop-down.
    - **Connection type**: `Public network`
    - **Database name**: `QuickSightDatabase`
    - **Username**: `admin` 
    - **Password**: enter in your RDS instance password
    - Select **Validate connection**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/Screenshot%202025-03-25%20194321.png?raw=true)

- Click **Create data source**.
- On the **Finish dataset creation** page, select **Directly query your data**.
- Click **Visualize**.

![App Screenshot](https://github.com/UXHERI/Cloud-Projects/blob/main/Visualize-RDS-Data-with-QuickSight/Images/Screenshot%202025-03-25%20194412.png?raw=true)

## 6. Visualize RDS Data

Finally, we are going to visualize our RDS data and create some charts from our data.

- Select the **Vertical Bar Chart** from the left hand **Visuals** section.
- Drag **jobs** into the **x-axis**.
- Drag **salary** into the **Value** measure.

![App SCreenshot](https://learn.nextwork.org/projects/static/aws-databases-rds/high-step9.1.png)

- Continue adding any other charts you feel like!
- When you're ready, select **Publish** in the top right.
- Name your dashboard `RDS New Hire Data`.
- Select **Publish Dashboard**.

_You have successfully completed this project by creating a relational database in AWS, connect it with AWS QuickSight and visualize your RDS data._

