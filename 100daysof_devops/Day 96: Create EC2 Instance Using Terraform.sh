The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units.

For this task, create an EC2 instance using Terraform with the following requirements:

The EC2 instance must use the value datacenter-ec2 as its Name tag, which defines the instance name in AWS.

Use the Amazon Linux ami-0c101f26f147fa7fd to launch this instance.

The Instance type must be t2.micro.

Create a new RSA key named datacenter-kp.

Attach the default (available by default) security group.

The Terraform working directory is /home/bob/terraform. Create the main.tf file (do not create a different .tf file) to provision the instance.

Note: Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.


 Configuration Details:

EC2 Instance Specifications:
- Name Tag: `datacenter-ec2`
- AMI: `ami-0c101f26f147fa7fd` (Amazon Linux)
- Instance Type: `t2.micro`
- Key Pair: `datacenter-kp` (newly created RSA key)
- Security Group: Default security group (automatically retrieved)
- Region: `us-east-1`

Key Features:

1. RSA Key Pair Creation:
   - Creates a new 4096-bit RSA key pair named `datacenter-kp`
   - Saves the private key locally as `datacenter-kp.pem` with proper permissions (0400)

2. Default Security Group:
   - Automatically finds and attaches the default security group from the default VPC

3. Outputs:
   - Instance ID
   - Public IP address
   - Private key file path

Steps to Deploy:

1. Navigate to the working directory:
   cd /home/bob/terraform
  
2. Create/Save the `main.tf` file with the configuration shown above
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

# Create RSA key pair
resource "tls_private_key" "datacenter_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "datacenter_kp" {
  key_name   = "datacenter-kp"
  public_key = tls_private_key.datacenter_key.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.datacenter_key.private_key_pem
  filename        = "${path.module}/datacenter-kp.pem"
  file_permission = "0400"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default security group
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

# Create EC2 instance
resource "aws_instance" "datacenter_ec2" {
  ami                    = "ami-0c101f26f147fa7fd"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.datacenter_kp.key_name
  vpc_security_group_ids = [data.aws_security_group.default.id]

  tags = {
    Name = "datacenter-ec2"
  }
}

# Output instance details
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.datacenter_ec2.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.datacenter_ec2.public_ip
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}

3. Initialize Terraform:
   terraform init

4. Validate the configuration:
   terraform validate

5. Preview the changes:
   terraform plan

6. Apply the configuration:
   terraform apply
   Type `yes` when prompted to confirm

7. View the outputs:
   terraform output
  
