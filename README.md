# PlanA Infrastructure and Application Deployment #

Tech Stacks Used:

1.CD- Github Actions
2. CI- Assumed that Niginx image is already available and hence didnt added CI Stage for Simplicity
3.Infra Provisioning- Terraform
4. Container Orchestrator- ECS Fargate

steps to reproduce:
1. Terraform - https://www.terraform.io/downloads.html -> Windows 64Bit and allow the download.
   unzip terraform.exe and add the AWS Access Key ID and secret access key to Windows Environment Variables.
   
    From Local Machine or remote server Trerraform Installed, navigate to PlanA\Resources\VPC to deploy Network with Public and Private Subnet and follow the below steps:

   ```bash
   terraform init 
   terraform validate
   terraform plan
   terraform apply --auto-approve
   
