# Troubleshooting Guide

Common issues encountered during the AWS IaC Terraform lab and their solutions.

## Terraform Validation & Initialization Issues

### Issue: `Error: Invalid or expired AWS credentials`

**Cause:** AWS credentials are not configured, invalid, or have expired.

**Solution:**
```bash
# Check credentials
aws sts get-caller-identity

# Reconfigure AWS
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export AWS_DEFAULT_REGION="us-east-1"

# Verify again
aws sts get-caller-identity
```

**Prevention:** Ensure temporary credentials are still valid before beginning work.

---

### Issue: `Error: Invalid provider version constraint`

**Cause:** Terraform or AWS provider version doesn't match requirements.

**Solution:**
```bash
# Check Terraform version
terraform version

# Verify it's >= 1.5.7. If not, upgrade from terraform.io/downloads

# Clear Terraform cache and reinitialize
rm -rf .terraform
terraform init
```

---

### Issue: `Error: validation failed: all required arguments must be provided`

**Cause:** Missing required variables in `terraform.tfvars`.

**Solution:**
1. Open `terraform.tfvars`
2. Ensure all required variables are set:
   - `project_name`
   - `environment`
   - `vpc_cidr_block`
   - `availability_zones`
   - `public_subnet_cidrs`
3. Check that values are not empty strings
4. Run `terraform validate` again

---

## CIDR Block & Network Configuration Issues

### Issue: `Error: Invalid CIDR block format`

**Cause:** CIDR blocks are not in proper notation (e.g., missing /prefix).

**Solution:**
1. Valid CIDR format examples:
   - `10.0.0.0/16` ✓
   - `10.0.1.0/24` ✓
   - `10.0.0.0` ✗ (missing /prefix)
   - `10.0.0.0/33` ✗ (invalid prefix for IPv4)

2. Edit `terraform.tfvars` and correct CIDR blocks
3. Use a [CIDR calculator](https://www.ipaddressguide.com/cidr) to verify ranges

---

### Issue: `Error: Overlapping CIDR blocks`

**Cause:** Subnet CIDR blocks overlap with VPC CIDR or each other.

**Example of error:**
```
10.0.0.0/16  - VPC CIDR
10.0.1.0/24  - Subnet 1 ✓ (within VPC range)
10.0.2.0/24  - Subnet 2 ✓ (within VPC range, no overlap)
10.0.1.0/25  - Subnet 3 ✗ (overlaps with Subnet 1)
```

**Solution:**
```bash
# Calculate correct subnets
# If VPC is 10.0.0.0/16, you can use:
# 10.0.0.0/24 - 10.0.255.0/24 (256 possible /24 subnets)

# Update terraform.tfvars with non-overlapping CIDRs
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]
```

---

### Issue: `Error: Not enough subnets for availability zones`

**Cause:** Number of subnet CIDR blocks doesn't match number of availability zones.

**Example:**
```hcl
availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]  # 3 AZs
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]               # Only 2 CIDRs
```

**Solution:**
```hcl
# Ensure matching counts
availability_zones  = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]
```

---

## Terraform State & Planning Issues

### Issue: `Error: Error reading state file`

**Cause:** Terraform state file is corrupted or inaccessible.

**Solution:**
```bash
# Backup current state (important!)
cp terraform.tfstate terraform.tfstate.backup

# Refresh state
terraform refresh

# If that doesn't work, reinitialize
rm -rf .terraform terraform.tfstate*
terraform init
terraform plan
```

**Warning:** Only do this if you haven't applied changes yet. If you have, state file corruption is serious.

---

### Issue: `Error: Plan shows different resource count than expected`

**Cause:** Variables might have unexpected values or counts might be miscalculated.

**Solution:**
```bash
# Check variable values in the plan
terraform plan -var-file=terraform.tfvars

# Verify specific variables
terraform console
> var.availability_zones
> length(var.availability_zones)
> length(var.public_subnet_cidrs)
```

Expected counts:
- 1 VPC
- 1 Internet Gateway
- N subnets (where N = number of availability zones)
- 1 Route Table
- N Route Table Associations

---

## AWS API & Permission Issues

### Issue: `Error: UnauthorizedOperation: You are not authorized to perform: ec2:CreateVpc`

**Cause:** AWS IAM permissions are insufficient.

**Solution:**
1. Verify the IAM user/role has these permissions:
   - ec2:CreateVpc
   - ec2:CreateInternetGateway
   - ec2:CreateSubnet
   - ec2:CreateRouteTable
   - ec2:AssociateRouteTable
   - ec2:AttachInternetGateway
   - ec2:CreateTags
   - ec2:DescribeVpcs
   - ec2:DescribeSubnets
   - ec2:DescribeRouteTables

2. Contact your lab administrator
3. Ensure you're using the correct AWS account

---

### Issue: `Error: Error launching source instance: AvailabilityZoneMismatch`

**Cause:** Specified availability zone doesn't exist in the region.

**Solution:**
```bash
# List available AZs for your region
aws ec2 describe-availability-zones --region us-east-1

# Update terraform.tfvars with valid AZs
# Example for us-east-1:
# availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
```

---

## Resource Naming & Tagging Issues

### Issue: `Error: Invalid resource name` or name is hardcoded

**Cause:** Resources use hardcoded names instead of variables.

**Solution:**
Review `main.tf` and ensure names use locals:
```hcl
# Correct (using locals)
resource "aws_vpc" "main" {
  tags = {
    Name = local.vpc_name
  }
}

# Incorrect (hardcoded)
resource "aws_vpc" "main" {
  tags = {
    Name = "my-vpc"
  }
}
```

---

### Issue: Tags are not being applied to resources

**Cause:** Resources missing tag blocks or default_tags not configured in provider.

**Solution:**
```hcl
# In versions.tf, ensure default_tags is configured
provider "aws" {
  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# In main.tf, add tags to all resources
tags = merge(
  local.common_tags,
  {
    Name = local.resource_name
  }
)
```

---

## Terraform Code Quality Issues

### Issue: `Error: Invalid resource naming - using hardcoded values`

**Solution:**
Ensure resource names conform to requirements:

✓ **Correct approaches:**
```hcl
# Using variables
name = var.resource_name

# Dynamic concatenation
name = "${var.project_name}-${var.environment}-resource"

# Using locals
name = local.resource_name
```

✗ **Incorrect approaches:**
```hcl
# Hardcoded
name = "my-resource"

# Using default
name = "resource-${var.environment}"  # Varies by terraform version
```

---

### Issue: `Error: Formatting issues in .tf files`

**Solution:**
```bash
# Format all files
terraform fmt -recursive

# Or specific file
terraform fmt main.tf

# Check formatting without changing
terraform fmt -check -recursive
```

---

## AWS Console Verification Issues

### Issue: Infrastructure doesn't appear in AWS Console after successful apply

**Cause:** Region mismatch between Terraform and AWS Console view.

**Solution:**
1. Check the region in AWS Console (top right)
2. Verify it matches `aws_region` in `terraform.tfvars`
3. Switch to correct region in Console

Example:
```hcl
# terraform.tfvars
aws_region = "us-east-1"
```

Check AWS Console is viewing `us-east-1`.

---

### Issue: Resources exist but don't match expected names

**Cause:** Resource naming convention issue in locals or variables.

**Solution:**
```bash
# Check actual resource names
terraform state show aws_vpc.main

# Review naming convention
# Check terraform.tfvars for project_name and environment
# Verify in main.tf that locals construct names correctly
```

---

## Cleanup & Destruction Issues

### Issue: `terraform destroy` fails or leaves resources

**Cause:** AWS service dependencies or IAM permissions.

**Solution:**
```bash
# Plan destruction first
terraform plan -destroy

# Force destroy with auto-approval (use with caution)
terraform destroy -auto-approve

# Manually verify in AWS Console that resources are deleted

# If manual cleanup needed, delete in this order:
# 1. Route Table Associations
# 2. Route Tables
# 3. Subnets
# 4. Internet Gateway (detach first)
# 5. VPC
```

---

## Getting Additional Help

If issues persist:

1. Review the complete error message (often has useful details)
2. Check [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
3. Review [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
4. Enable debug logging:
   ```bash
   export TF_LOG=DEBUG
   terraform plan
   ```
5. Check AWS CloudTrail for API errors in Console

---

## Prevention Checklist

To avoid common issues:

- [ ] Verify AWS credentials before starting
- [ ] Double-check CIDR blocks with a calculator
- [ ] Ensure subnet count matches AZ count
- [ ] Run `terraform fmt` before validating
- [ ] Review `terraform plan` output carefully
- [ ] Test on small resource set first
- [ ] Keep terraform.tfstate files backed up
- [ ] Document your parameter values
- [ ] Verify region/AZ availability in target account

---

**Last Updated:** February 2026  
**Version:** 1.0
