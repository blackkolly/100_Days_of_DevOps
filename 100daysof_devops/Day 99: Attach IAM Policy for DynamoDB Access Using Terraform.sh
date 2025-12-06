The DevOps team has been tasked with creating a secure DynamoDB table and enforcing fine-grained access control using IAM. This setup will allow secure and restricted access to the table from trusted AWS services only.

As a member of the Nautilus DevOps Team, your task is to perform the following using Terraform:

Create a DynamoDB Table: Create a table named devops-table with minimal configuration.

Create an IAM Role: Create an IAM role named devops-role that will be allowed to access the table.

Create an IAM Policy: Create a policy named devops-readonly-policy that should grant read-only access (GetItem, Scan, Query) to the specific DynamoDB table and attach it to the role.

Create the main.tf file (do not create a separate .tf file) to provision the table, role, and policy.

Create the variables.tf file with the following variables:

KKE_TABLE_NAME: name of the DynamoDB table
KKE_ROLE_NAME: name of the IAM role
KKE_POLICY_NAME: name of the IAM policy
Create the outputs.tf file with the following outputs:

kke_dynamodb_table: name of the DynamoDB table
kke_iam_role_name: name of the IAM role
kke_iam_policy_name: name of the IAM policy
Define the actual values for these variables in the terraform.tfvars file.

Ensure that the IAM policy allows only read access and restricts it to the specific DynamoDB table created.


Notes:

The Terraform working directory is /home/bob/terraform.

Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.

Before submitting the task, ensure that terraform plan returns No changes. Your infrastructure matches the configuration.




 File 1: main.tf 

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

resource "aws_dynamodb_table" "devops_table" {
  name           = var.KKE_TABLE_NAME
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = var.KKE_TABLE_NAME
  }
}

resource "aws_iam_role" "devops_role" {
  name = var.KKE_ROLE_NAME

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = var.KKE_ROLE_NAME
  }
}

resource "aws_iam_policy" "devops_readonly_policy" {
  name        = var.KKE_POLICY_NAME
  description = "Read-only access policy for DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = aws_dynamodb_table.devops_table.arn
      }
    ]
  })

  tags = {
    Name = var.KKE_POLICY_NAME
  }
}

resource "aws_iam_role_policy_attachment" "devops_policy_attachment" {
  role       = aws_iam_role.devops_role.name
  policy_arn = aws_iam_policy.devops_readonly_policy.arn
}

 File 2: variables.tf 

variable "KKE_TABLE_NAME" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "KKE_ROLE_NAME" {
  description = "Name of the IAM role"
  type        = string
}

variable "KKE_POLICY_NAME" {
  description = "Name of the IAM policy"
  type        = string
}

File 3: outputs.tf 
output "kke_dynamodb_table" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.devops_table.name
}

output "kke_iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.devops_role.name
}

output "kke_iam_policy_name" {
  description = "Name of the IAM policy"
  value       = aws_iam_policy.devops_readonly_policy.name
}


 File 4: terraform.tfvars 
KKE_TABLE_NAME  = "devops-table"
KKE_ROLE_NAME   = "devops-role"
KKE_POLICY_NAME = "devops-readonly-policy"



 What This Configuration Creates:

1. DynamoDB Table (`devops-table`)
   - Billing Mode: PAY_PER_REQUEST (on-demand pricing)
   - Primary Key: `id` (String type)
   - Minimal configuration as requested

2. IAM Role (`devops-role`)
   - Trust Policy: Allows EC2 service to assume this role
   - Purpose: Can be assumed by AWS services to access DynamoDB

3. IAM Policy (`devops-readonly-policy`)
   - Permissions: Read-only access
     - `dynamodb:GetItem` - Read single item
     - `dynamodb:Scan` - Read all items
     - `dynamodb:Query` - Query items
   - Scope: Restricted to the specific `devops-table` only
   - Security: No write/delete permissions

4. Policy Attachment
   - Links the policy to the role

Deployment Steps:

1. Navigate to working directory:
   cd /home/bob/terraform
  

2. Create all four files in `/home/bob/terraform/`:
   - `main.tf`
   - `variables.tf`
   - `outputs.tf`
   - `terraform.tfvars`

3. Verify files are created:
   ls -la *.tf*
   Should show: `main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`

4. Initialize Terraform:
   terraform init
  
5. Validate configuration:
   terraform validate
   Should return: `Success! The configuration is valid.`

6. Preview changes:
   terraform plan
   Should show 4 resources to be created

7. Apply configuration:
   terraform apply
   Type `yes` when prompted

8. View outputs:
   terraform output

9. Verify no changes
   terraform plan
  
