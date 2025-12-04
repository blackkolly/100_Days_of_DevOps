The Nautilus DevOps team is expanding their AWS infrastructure and requires the setup of a private Virtual Private Cloud (VPC) along with a subnet. This VPC and subnet configuration will ensure that resources deployed within them remain isolated from external networks and can only communicate within the VPC. Additionally, the team needs to provision an EC2 instance under the newly created private VPC. This instance should be accessible only from within the VPC, allowing for secure communication and resource management within the AWS environment.

Create a VPC named datacenter-priv-vpc with the CIDR block 10.0.0.0/16.

Create a subnet named datacenter-priv-subnet inside the VPC with the CIDR block 10.0.1.0/24 and auto-assign IP option must not be enabled.

Create an EC2 instance named datacenter-priv-ec2 inside the subnet and instance type must be t2.micro.

Ensure the security group of the EC2 instance allows access only from within the VPC's CIDR block.

Create the main.tf file (do not create a separate .tf file) to provision the VPC, subnet and EC2 instance.

Use variables.tf file with the following variable names:

KKE_VPC_CIDR for the VPC CIDR block.
KKE_SUBNET_CIDR for the subnet CIDR block.
Use the outputs.tf file with the following variable names:

KKE_vpc_name for the name of the VPC.
KKE_subnet_name for the name of the subnet.
KKE_ec2_private for the name of the EC2 instance.

Notes:

The Terraform working directory is /home/bob/terraform.

Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.

Before submitting the task, ensure that terraform plan returns No changes. Your infrastructure matches the configuration.





File 1: `main.tf`
Contains the main infrastructure resources:
- VPC: `datacenter-priv-vpc` with CIDR `10.0.0.0/16`
- Subnet: `datacenter-priv-subnet` with CIDR `10.0.1.0/24` (auto-assign IP disabled)
- Security Group: Allows access only from within VPC CIDR block
- EC2 Instance: `datacenter-priv-ec2` (t2.micro) using latest Amazon Linux 2 AMI
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "datacenter_priv_vpc" {
  cidr_block           = var.KKE_VPC_CIDR
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "datacenter-priv-vpc"
  }
}

resource "aws_subnet" "datacenter_priv_subnet" {
  vpc_id                  = aws_vpc.datacenter_priv_vpc.id
  cidr_block              = var.KKE_SUBNET_CIDR
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "datacenter-priv-subnet"
  }
}

resource "aws_security_group" "datacenter_priv_sg" {
  name        = "datacenter-priv-sg"
  description = "Security group allowing access only from within VPC"
  vpc_id      = aws_vpc.datacenter_priv_vpc.id

  ingress {
    description = "Allow all traffic from within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.KKE_VPC_CIDR]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "datacenter-priv-sg"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "datacenter_priv_ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.datacenter_priv_subnet.id
  vpc_security_group_ids = [aws_security_group.datacenter_priv_sg.id]

  tags = {
    Name = "datacenter-priv-ec2"
  }
}

File 2: `variables.tf`
Defines the required variables:
- `KKE_VPC_CIDR` = `10.0.0.0/16`
- `KKE_SUBNET_CIDR` = `10.0.1.0/24`
variable "KKE_VPC_CIDR" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "KKE_SUBNET_CIDR" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

File 3: `outputs.tf`
Defines the required outputs:
- `KKE_vpc_name` - VPC name
- `KKE_subnet_name` - Subnet name
- `KKE_ec2_private` - EC2 instance name
output "KKE_vpc_name" {
  description = "Name of the VPC"
  value       = aws_vpc.datacenter_priv_vpc.tags["Name"]
}

output "KKE_subnet_name" {
  description = "Name of the subnet"
  value       = aws_subnet.datacenter_priv_subnet.tags["Name"]
}

output "KKE_ec2_private" {
  description = "Name of the EC2 instance"
  value       = aws_instance.datacenter_priv_ec2.tags["Name"]
}

Deployment Steps:

terraform init
terraform validate
terraform plan
terraform apply
