When establishing infrastructure on the AWS cloud, Identity and Access Management (IAM) is among the first and most critical services to configure. IAM facilitates the creation and management of user accounts, groups, roles, policies, and other access controls. The Nautilus DevOps team is currently in the process of configuring these resources and has outlined the following requirements.
Create an IAM policy named iampolicy_mariyam in us-east-1 region using Terraform. It must allow read-only access to the EC2 console, i.e., this policy must allow users to view all instances, AMIs, and snapshots in the Amazon EC2 console.
The Terraform working directory is /home/bob/terraform. Create the main.tf file (do not create a different .tf file) to accomplish this task.
Note: Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.

Configuration Details:

IAM Policy Specifications:
- Policy Name: `iampolicy_mariyam`
- Region: `us-east-1`
- Description: Read-only access to EC2 console
- Access Level: Read-only (no modification permissions)

Policy Permissions:
The policy allows the following EC2 actions:
- `ec2:Describe` - View all EC2 resource details (instances, AMIs, snapshots, volumes, etc.)
- `ec2:Get` - Retrieve EC2 resource information
- `ec2:List` - List all EC2 resources


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

resource "aws_iam_policy" "iampolicy_mariyam" {
  name        = "iampolicy_mariyam"
  description = "Read-only access to EC2 console - allows viewing instances, AMIs, and snapshots"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = aws_iam_policy.iampolicy_mariyam.arn
}

output "policy_name" {
  description = "Name of the created IAM policy"
  value       = aws_iam_policy.iampolicy_mariyam.name
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

7. View the policy ARN:
   terraform output
   

