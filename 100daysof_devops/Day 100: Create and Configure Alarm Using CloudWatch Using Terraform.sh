The Nautilus DevOps team has been tasked with setting up an EC2 instance for their application. To ensure the application performs optimally, they also need to create a CloudWatch alarm to monitor the instance's CPU utilization. The alarm should trigger if the CPU utilization exceeds 90% for one consecutive 5-minute period. To send notifications, use the SNS topic named xfusion-sns-topic, which is already created.

Launch EC2 Instance: Create an EC2 instance named xfusion-ec2 using any appropriate Ubuntu AMI (you can use AMI ami-0c02fb55956c7d316).

Create CloudWatch Alarm: Create a CloudWatch alarm named xfusion-alarm with the following specifications:

Statistic: Average
Metric: CPU Utilization
Threshold: >= 90% for 1 consecutive 5-minute period
Alarm Actions: Send a notification to the xfusion-sns-topic SNS topic.
Update the main.tf file (do not create a separate .tf file) to create a EC2 Instance and CloudWatch Alarm.

Create an outputs.tf file to output the following values:

KKE_instance_name for the EC2 instance name.
KKE_alarm_name for the CloudWatch alarm name.

Notes:

The Terraform working directory is /home/bob/terraform.

Right-click under the EXPLORER section in VS Code and select Open in Integrated Terminal to launch the terminal.

Before submitting the task, ensure that terraform plan returns No changes. Your infrastructure matches the configuration.




main.tf - Contains:

# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Adjust region as needed
}

# Get current AWS account ID and region
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Construct the SNS topic ARN
locals {
  sns_topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:devops-sns-topic"
}

# EC2 Instance
resource "aws_instance" "devops_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"  # Adjust instance type as needed

  tags = {
    Name = "devops-ec2"
  }
}

# CloudWatch Alarm for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "devops_alarm" {
  alarm_name          = "devops-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5 minutes in seconds
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = [data.aws_sns_topic.devops_topic.arn]

  dimensions = {
    InstanceId = aws_instance.devops_ec2.id
  }
}

outputs.tf

# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Adjust region as needed
}

# Get current AWS account ID and region
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Construct the SNS topic ARN
locals {
  sns_topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:devops-sns-topic"
}

# EC2 Instance
resource "aws_instance" "devops_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"  # Adjust instance type as needed

  tags = {
    Name = "devops-ec2"
  }
}

# CloudWatch Alarm for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "devops_alarm" {
  alarm_name          = "devops-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300  # 5 minutes in seconds
  statistic           = "Average"
  threshold           = 90
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = [local.sns_topic_arn]

  dimensions = {
    InstanceId = aws_instance.devops_ec2.id
  }
}

Navigate to `/home/bob/terraform` in VS Code

terraform init
terraform plan
terraform apply
