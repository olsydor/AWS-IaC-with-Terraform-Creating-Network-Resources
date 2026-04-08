# Quick Start Guide

## Prerequisites
- Terraform >= 1.5.7 installed
- AWS CLI configured with temporary credentials
- Text editor or IDE for editing Terraform files

## Step-by-Step Setup

### 1. Configure Your Parameters

Edit `terraform.tfvars` and fill in the parameters from your task:

```hcl
project_name       = "your-project-name"
environment        = "dev"
vpc_cidr_block     = "10.0.0.0/16"  # from task parameters
availability_zones = ["us-east-1a", "us-east-1b"]  # from task parameters
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]  # from task parameters
```

### 2. Initialize Terraform

```bash
terraform init
```

This command will download the AWS provider and set up the local Terraform environment.

### 3. Validate Configuration

```bash
terraform validate
```

Ensure there are no syntax errors in your configuration.

### 4. Format Configuration

```bash
terraform fmt
```

This ensures your code follows Terraform style conventions.

### 5. Review the Plan

```bash
terraform plan
```

Review the output to verify:
- ✓ VPC is being created with correct CIDR
- ✓ Internet Gateway is being attached
- ✓ Public subnets are created in multiple AZs
- ✓ Route table is created with IGW route

### 6. Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted to confirm. This will create your AWS infrastructure.

### 7. Verify in AWS Console

After successful apply:

1. Open AWS Console → VPC Dashboard
2. Verify VPC exists with correct CIDR block
3. Check Internet Gateway is attached
4. Confirm public subnets across availability zones
5. Review route table with route to Internet Gateway

### 8. View Outputs

```bash
terraform output
```

This shows important resource IDs and information about your infrastructure.

## Common Commands

```bash
# Show current state
terraform state list
terraform state show resource_name

# Destroy all resources
terraform destroy

# Format all files
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan with output file
terraform plan -out=tfplan
terraform apply tfplan
```

## Troubleshooting

### Error: "Invalid or expired AWS credentials"
- Check AWS credentials: `aws sts get-caller-identity`
- Re-configure: `aws configure`
- Verify temporary credentials haven't expired

### Error: "CIDR blocks overlap"
- Ensure each subnet CIDR is unique and within VPC CIDR
- Use [CIDR calculator](https://www.ipaddressguide.com/cidr) to verify ranges

### Error: "Too many availability zones"
- Check you have matching subnet CIDR blocks for each AZ
- Count AZs should equal count of subnet CIDRs

## Next Steps

Once your network infrastructure is created:

1. Deploy EC2 instances in the public subnets
2. Add private subnets for backend resources
3. Create Network ACLs for additional security
4. Add security groups for instance-level firewall rules
5. Set up VPN or bastion hosts for management access

## Useful Links

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform Best Practices](https://www.terraform.io/docs/best-practices)
