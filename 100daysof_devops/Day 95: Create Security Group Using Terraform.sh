
The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units. This granular approach enables the team to execute the migration in gradual phases, ensuring smoother implementation and minimizing disruption to ongoing operations. By breaking down the migration into smaller tasks, the Nautilus DevOps team can systematically progress through each stage, allowing for better control, risk mitigation, and optimization of resources throughout the migration process.
Use Terraform to create a security group under the default VPC with the following requirements:
1) The name of the security group must be nautilus-sg.
2) The description must be Security group for Nautilus App Servers.
3) Add an inbound rule of type HTTP, with a port range of 80, and source CIDR range 0.0.0.0/0.
4) Add another inbound rule of type SSH, with a port range of 22, and source CIDR range 0.0.0.0/0.
Ensure that the security group is created in the us-east-1 region using Terraform. The Terraform working directory is /home/bob/terraform. Create the main.tf file (do not create a different .tf file) to accomplish this task.
Note: Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.


Configuration Details:

Security Group Specifications:
- Name: `nautilus-sg`
- Description: `Security group for Nautilus App Servers`
- VPC: Default VPC (automatically retrieved using data source)
- Region: `us-east-1`

Inbound Rules:
1. HTTP Rule:
   - Protocol: TCP
   - Port: 80
   - Source: `0.0.0.0/0` (anywhere)

2. SSH Rule:
   - Protocol: TCP
   - Port: 22
   - Source: `0.0.0.0/0` (anywhere)

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

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "nautilus_sg" {
  name        = "nautilus-sg"
  description = "Security group for Nautilus App Servers"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nautilus-sg"
  }
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

7. verify the security group:
   terraform show
  

Key Features:

- Data Source: Uses `data "aws_vpc" "default"` to automatically find the default VPC ID
- Ingress Rules: Both HTTP and SSH rules allow traffic from anywhere (`0.0.0.0/0`)
- Tags: Includes a Name tag for easy identification in the AWS Console
- Best Practices: Includes descriptions for each ingress rule for better documentation

