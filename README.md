# AWS IaC with Terraform: Creating Network Resources

## Lab Description

The objective of this lab is to create a foundational network stack for your virtual infrastructure in AWS using Terraform. This involves setting up a customized Virtual Private Cloud (VPC), internet gateway, public subnets in multiple availability zones, and a routing table to manage the traffic flow.

## Prerequisites

- AWS Account with temporary credentials
- Terraform installed (version >= 1.5.7)
- Basic understanding of AWS networking concepts
- Git configured for repository management

## Getting Started

### Step 1: Study the Instructions

Read through this entire document and the task requirements carefully. This will help you execute tasks efficiently and avoid unnecessary mistakes.

### Step 2: Enter Input Parameters

Before starting, you will receive the following parameters from your task environment:

- `vpc_cidr_block` - CIDR block for your VPC
- `environment` - Environment name (e.g., dev, staging, prod)
- `availability_zones` - List of availability zones for subnet deployment
- `public_subnet_cidrs` - CIDR blocks for public subnets

Once you have these parameters, update the `terraform.tfvars` file accordingly.

### Step 3: Install Terraform

If you haven't already installed Terraform, visit the [official Terraform documentation](https://www.terraform.io/downloads) and download version 1.5.7 or later for your operating system.

```bash
# Verify installation
terraform version
# Expected output: Terraform v1.5.7 or higher
```

### Step 4: Configure AWS Provider

Ensure your AWS credentials are configured:

```bash
# Using AWS CLI
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

**Reference:** [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### Step 5: Review Terraform Configuration Files

The configuration consists of the following files:

- **versions.tf** - Defines Terraform and AWS provider versions
- **variables.tf** - Input variables for the infrastructure
- **main.tf** - Resource definitions (VPC, subnets, internet gateway, routing table)
- **outputs.tf** - Output values for infrastructure information
- **terraform.tfvars** - Input variable values (configure with your parameters)

### Step 6: Develop and Validate

1. Review each `.tf` file to understand the infrastructure being created
2. Customize values in `terraform.tfvars` with your specific parameters
3. Validate the configuration:

```bash
terraform init
terraform validate
terraform fmt -check
terraform plan
```

4. Review the plan output to ensure all resources match your expectations
5. If everything looks correct, apply the configuration:

```bash
terraform apply
```

### Step 7: Push Code to Your Repository

Once your Terraform configuration is validated and applied:

```bash
git add .
git commit -m "feat: Create AWS network stack with Terraform"
git push origin main
```

### Step 8: Verify Your Infrastructure

After applying the configuration:

1. Check the outputs displayed by Terraform
2. Verify in AWS Console:
   - Navigate to VPC Dashboard
   - Confirm VPC creation with correct CIDR block
   - Verify public subnets in multiple availability zones
   - Check internet gateway attachment
   - Confirm routing table configuration

3. Run validation script (if available):

```bash
terraform refresh
terraform output
```

## Common Task Requirements

The following requirements are enforced in this lab:

### ✓ Terraform Backend
- **Do NOT** define the backend in configuration
- Terraform will use the local backend by default
- This temporary AWS account will be automatically cleaned after expiration

### ✓ Provisioners
- **Avoid** using the `local-exec` provisioner
- **Prohibited:** `prevent_destroy` lifecycle attribute

### ✓ File Organization
- `versions.tf` - Required versions declarations only
- `variables.tf` - All input variables with descriptions and types
- `main.tf` - Resource definitions
- `outputs.tf` - Output declarations with descriptions
- `terraform.tfvars` - Input values for non-sensitive parameters

### ✓ Version Requirements
- Terraform: `>= 1.5.7`
- AWS Provider: Latest compatible version

### ✓ Code Standards
- Use `terraform fmt` to format all `.tf` files
- All variables require:
  - Valid type definitions (`string`, `list`, `map`, etc.)
  - Clear and descriptive descriptions
- All outputs require:
  - Valid descriptions
  - Clear output names
- Resource names via:
  - Variables
  - Dynamic generation/concatenation using Terraform functions
  - **Never** hardcode resource names

### ✓ Configuration Values
- All non-sensitive input parameters in `terraform.tfvars`
- Sensitive values handled via environment variables or AWS provider configuration

## Resources to Be Created

### 1. Virtual Private Cloud (VPC)
- Custom CIDR block
- DNS hostnames enabled
- DNS resolution enabled

### 2. Internet Gateway
- Attached to the VPC
- Proper naming convention

### 3. Public Subnets
- Created in multiple availability zones
- Each with assigned CIDR blocks
- Public IP assignment enabled
- Proper naming and tagging

### 4. Route Table
- Associated with public subnets
- Default route to Internet Gateway
- Proper naming convention

## Cleanup

When finished with the lab and ready to clean up resources:

```bash
terraform destroy
```

This will remove all AWS resources created by this Terraform configuration. Note that your temporary AWS account will be automatically cleaned after the lab expiration time.

## Troubleshooting

### Issue: Terraform validation fails
- Ensure all variables are properly typed in `variables.tf`
- Run `terraform fmt` to fix formatting issues
- Check variable descriptions are non-empty strings

### Issue: AWS Provider authentication fails
- Verify AWS credentials are configured
- Check temporary credentials haven't expired
- Ensure AWS_DEFAULT_REGION is set

### Issue: Resource naming conflicts
- Verify environment name is unique
- Check that variables are properly used for resource names
- Use `terraform plan` to see actual resource names before applying

### Issue: Subnet CIDR blocks overlap
- Ensure all subnet CIDR blocks are within VPC CIDR range
- Verify no overlapping CIDR blocks between subnets
- Use CIDR calculator to validate ranges

## Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform Best Practices](https://www.terraform.io/cloud-docs/state/terraform-files)

## Lab Summary

By completing this lab, you will have:

✓ Created a VPC with custom CIDR block  
✓ Configured an Internet Gateway for public internet access  
✓ Deployed public subnets across multiple availability zones  
✓ Set up routing infrastructure for traffic management  
✓ Applied Terraform best practices and code standards  
✓ Pushed infrastructure-as-code to a repository  

This foundational network stack serves as the basis for deploying additional AWS resources like EC2 instances, load balancers, and databases.
