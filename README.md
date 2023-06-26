# Web-Server-on-AWS-using-Terraform
Terraform beginners project

Project Document: Setting Up a Web Server on AWS using Terraform

**Introduction:**
This document outlines the steps and resources required to set up a web server infrastructure on Amazon Web Services (AWS) using Terraform. The infrastructure includes a Virtual Private Cloud (VPC), an internet gateway, a route table, a subnet, a security group, and an EC2 instance running a web server.

**Prerequisites:**
Before proceeding with the setup, ensure that you have the following prerequisites:

An AWS account with appropriate permissions to create resources.
Terraform installed on your local machine.
An SSH key pair for accessing the EC2 instance.
Terraform Code Explanation:
The provided Terraform code defines the resources required for the web server infrastructure. Let's go through each resource block:
VPC (aws_vpc):

The VPC resource creates a Virtual Private Cloud with the CIDR block "10.0.0.0/16" and assigns the tag "Prod_VPC" to it.
Internet Gateway (aws_internet_gateway):

The internet gateway resource establishes a connection between the VPC and the internet.
It references the VPC created above by using its ID.
Route Table (aws_route_table):

The route table resource manages the routing within the VPC.
It associates the route table with the VPC.
It adds a default route (0.0.0.0/0) to the internet gateway created above.
Subnet (aws_subnet):

The subnet resource creates a subnet within the VPC with the CIDR block "10.0.1.0/24" and assigns the tag "prod_subnet" to it.
It specifies the availability zone as "us-east-1a".
Route Table Association (aws_route_table_association):

The route table association resource associates the subnet with the route table.
It references the subnet and route table by using their respective IDs.
Security Group (aws_security_group):

The security group resource defines the inbound and outbound traffic rules for the EC2 instance.
It allows inbound SSH (port 22), HTTP (port 80), and HTTPS (port 443) traffic from any IP address.
It allows all outbound traffic.
It assigns the tag "Web-traffic" to the security group.
EC2 Instance (aws_instance):

The EC2 instance resource launches an instance using the specified Amazon Machine Image (AMI) and instance type.
It assigns the provided SSH key pair for SSH access.
It specifies the availability zone as "us-east-1a".
It executes the provided user data script on instance launch, which installs Apache web server and creates an index.html file.
