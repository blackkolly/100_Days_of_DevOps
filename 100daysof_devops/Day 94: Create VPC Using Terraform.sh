The Nautilus DevOps team is strategizing the migration of a portion of their infrastructure to the AWS cloud. Recognizing the scale of this undertaking, they have opted to approach the migration in incremental steps rather than as a single massive transition. To achieve this, they have segmented large tasks into smaller, more manageable units. This granular approach enables the team to execute the migration in gradual phases, ensuring smoother implementation and minimizing disruption to ongoing operations. By breaking down the migration into smaller tasks, the Nautilus DevOps team can systematically progress through each stage, allowing for better control, risk mitigation, and optimization of resources throughout the migration process.

Create a VPC named devops-vpc in region us-east-1 with any IPv4 CIDR block through terraform.

The Terraform working directory is /home/bob/terraform. Create the main.tf file (do not create a different .tf file) to accomplish this task.

Note: Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.



Configuration Details:

- VPC Name: `devops-vpc` (set via tags)
- Region: `us-east-1`
- CIDR Block: `10.0.0.0/16` (provides 65,536 IP addresses)
- Provider: AWS with version constraint `~> 5.0`

Steps to Deploy:

1. Navigate to the working directory:
   cd /home/bob/terraform

2. Save the configuration as `main.tf` in that directory
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

resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "devops-vpc"
  }
}

3. Initialize Terraform (downloads the AWS provider):
   terraform init

4. Review the execution plan:
   terraform plan

5. Apply the configuration:
   terraform apply
   Type `yes` when prompted to confirm

6.Verify the VPC was created:
   terraform show

What This Creates:

- A VPC in `us-east-1` with CIDR block `10.0.0.0/16`
- The VPC will be tagged with the name "devops-vpc"
- Default VPC settings (DNS support, DNS hostnames, etc.)

Note on CIDR Block:

I've used `10.0.0.0/16` which is a common private IP range. You can change this to any valid IPv4 CIDR block if needed:
- `10.0.0.0/16` (65,536 IPs)
- `172.16.0.0/16` (65,536 IPs)
- `192.168.0.0/16` (65,536 IPs)

