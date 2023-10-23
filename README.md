# 16-ACS-Terraform
Automate Infrastructure as a code using Terraform on AWS . Part1 - Complexity - Medium
---

### The goal is to automate the Cloud solution to build 2 websites using Terraform to set up the infrastructure on AWS .
#


Project architecture
![Project-Architecture](/images/Architecture.png)

Prerequisites before you begin writing Terraform code:
---
1. You must have an understanding of Terraform and how it works

2. Create an IAM user, name it terraform (ensure that the user has only programatic access to your AWS account) and grant this user AdministratorAccess permissions.

3. Copy the secret access key and access key ID. Save them in a notepad temporarily.

4. Configure programmatic access from your workstation to connect to AWS using the access keys copied above and a Python SDK (boto3). You must have Python 3.6 or higher on your workstation.

For easier authentication configuration – use AWS CLI with aws configure command.

Create an S3 bucket to store Terraform state file. 

(Note: S3 bucket names must be unique unique within a region partition, you can read about S3 bucken naming in this article). We will use this bucket in the next project onwards maybe all through to container orchestration with Kubernetes.

When you have configured authentication and installed boto3, make sure you can programmatically access your AWS account by running following commands in >python:

```
import boto3
s3 = boto3.resource('s3')
for bucket in s3.buckets.all():
    print(bucket.name)

```
You shall see your previously created S3 bucket name – <yourname>-dev-terraform-bucket


---

#### The secrets of writing quality Terraform code #

The secret recipe of a successful Terraform projects consists of:

Your understanding of your goal (desired AWS infrastructure end state)

Your knowledge of the IaC technology used (in this case – Terraform)

Your ability to effectively use up to date Terraform documentation

As you go along completing this project, you will get familiar with Terraform-specific terminology, such as:

Attribute
Resource
Interpolations
Argument
Providers
Provisioners
Input Variables
Output Variables
Module
Data Source
Local Values
Backend

Make sure you understand them and know when to use each of them.

Another concept you must know is **data type** . This is a general programing concept, it refers to how data represented in a programming language and defines how a compiler or interpreter can use the data. Common data types are:

Integer
Float
String
Boolean, etc.
Best practices

Ensure that every resource is tagged using multiple key-value pairs. You will see this in action as we go along.

Try to write reusable code, avoid hard coding values wherever possible. (For learning purpose, we will start by hard coding, but gradually refactor our work to follow best practices).


---

Create an IAM user and attach the right policies

Install AWS CLI to use AWS resources via commands on the cLI . You can use this official guide:

```
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

```

Note: debug logs are stored in 

`/var/log/install.log`

Create an S3 Bucket 

`david-dev-terraform-bucket`
---
s3 bucket created
![S3 Bucket Created](/images/S3-bucketsCreated.png)

aws-cli set up
![awscli-created](/images/AWS-CLI-configured.png)



---
From the Architecture, first we create the **VPC**

VPC | SUBNETS | SECURTY GROUPS

In VSCODE ,Create a Folder called PBL
create a file inside the folder called `main.tf`

---
** Create a Provider and VPC Resource section **

- Add AWS as a provider and add a resource to create the VPC in the main.tf file

- The provider block informs Terraform that we intend to build our infrastructure in AWS
- The resource block will create the VPC

Next, I'll install some plugins - **_providers_** and **_provisioners_** . These plugins are required for terraform to work. For now, I only have "provider block in the main.tf" code so ,Terraform will only download AWS provider plugin for now.

From the PBL folder - the `main.tf` location, run `terraform init` to download the plugins. => You'll find them in the newly created .terraform/ folder in the project directory

TIPS : Run `terraform fmt` and `terraform validate` to format and test your configuration
`terraform plan` to see what terraform plans to run

`terraform apply`

---
**_Subnets Resource Section_**

The project architecture requires 6 subnets.

Public Subnets     - 2 
Private Subnets    - 2 
Data-Layer Subnets - 2

---
 BASIC main.tf file before refactor

```


provider "aws" {
  region = "us-east-2"
}
# CREATE VPC
resource "aws_vpc" "main" {

  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

}

# CREATE PUBLIC SUBNETS
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a"
}
# CREATE PRIVATE SUBNET
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2b"
}


```
VPC with 3 resources created on Terraform apply

![VPC Creation](/images/terraform-apply.png)

![Terraform ](/images/TerraformApply-3resources.png)


This is a basic implementation. For best **practices** to allow us specify multiple resource blocks, I'll destroy the newly created infrastructure with `terraform apply` and  refactor this first with separate variable.tf & terraform.tfvars. 
---

REFACTOR
---
I'll introduce VARIABLES . starting with the PROVIDER block , i'll introduce variables for the other resources

variables
![Variables](/images/variables-refactor.png)

-------
#### Closer look at the `cidrsubnet()` function
- It is Dynamic, makes it easier to create CIDR subnets in availability zone .
Parameters are `cidrsubnets(prefix, newbit, netnum)`
- the prefix parameter must be given in CIDR notation, same as VPC

- The newbits params is the number of additional bits with which to extend the prefix. E.G with a given prefix of /16 and newbits value of '4' ,the resulting subnet address length will be /20.

- The netnum is a new number that can be represented and not more than than newbits that can be used to populate additional bits added to the prefix .
- you can test how it works in `terraform console`

---


#### Introduce variable.tf & terraform.tfvars

Instead of a long main.tf file, I'll restructure the code and move some parts to other files for a better structure and to make it more dynamic.
- Move all variables to a variables.tf file and make the values non default
- create a terraform.tfvars file and set values to it

> see repo for code

TERRAFORM PLAN
![terraform plan](/images/Terraform-Plan-Final.png)

TERRAFORM APPLY
![Terraform apply](/images/terraform-apply.png)

CONSOLE view
![comsole](/images/Console.png)

---
Refer to the repo.
















