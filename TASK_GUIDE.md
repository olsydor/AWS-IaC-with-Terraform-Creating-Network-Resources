# AWS IaC with Terraform: Task Execution Guide

## Task Overview

Create a foundational network stack in AWS using Terraform with the following specific resources:

- **VPC**: cmtr-5bc36296-01-vpc (10.10.0.0/16)
- **Public Subnets** (3 across different AZs):
  - cmtr-5bc36296-01-subnet-public-a (10.10.1.0/24 in us-east-1a)
  - cmtr-5bc36296-01-subnet-public-b (10.10.3.0/24 in us-east-1b)
  - cmtr-5bc36296-01-subnet-public-c (10.10.5.0/24 in us-east-1c)
- **Internet Gateway**: cmtr-5bc36296-01-igw
- **Route Table**: cmtr-5bc36296-01-rt

## File Structure

```
terraform-network-lab/
├── versions.tf              # Terraform and provider version requirements
├── variables.tf             # Input variables for the configuration
├── main.tf                  # Backend and provider configuration
├── vpc.tf                   # VPC resources definition
├── outputs.tf               # Output values
├── terraform.tfvars         # Input variable values
├── .gitignore               # Git ignore rules
├── README.md                # Comprehensive documentation
├── QUICKSTART.md            # Quick reference guide
├── VERIFICATION_CHECKLIST.md # Pre-submission checklist
├── TROUBLESHOOTING.md       # Common issues and solutions
└── TASK_GUIDE.md           # This file
```

## Prerequisites

### 1. Tools & Software
- **Terraform**: >= 1.5.7 ([Download](https://www.terraform.io/downloads))
- **AWS CLI**: Latest version ([Download](https://aws.amazon.com/cli/))
- **Git**: For version control

### 2. AWS Credentials

Use the provided sandbox credentials:

```bash
# Option 1: Using environment variables (Recommended for temporary credentials)
export AWS_ACCESS_KEY_ID="AKIAQ4J5YFKSYB6Y2OMI"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-east-1"

# Option 2: Using AWS CLI configuration
aws configure
# When prompted:
# AWS Access Key ID: AKIAQ4J5YFKSYB6Y2OMI
# AWS Secret Access Key: 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
# Default region: us-east-1
# Default output format: json
```

### 3. Time Constraint

⏱️ **Important**: You have 2.5 hours from the task start time (2026-02-25 10:02:28 to 12:32:28 UTC) to complete verification. After this period, all infrastructure will be automatically destroyed.

## Step-by-Step Execution

### Step 1: Verify Configuration Files

All configuration is already prepared with the correct values. Verify the files:

```bash
# Check variables are set correctly
cat terraform.tfvars

# Expected output should show:
# vpc_name = "cmtr-5bc36296-01-vpc"
# vpc_cidr_block = "10.10.0.0/16"
# availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
# etc.
```

### Step 2: Initialize Terraform

```bash
terraform init
```

**Expected output**: Terraform initializes successfully, downloads AWS provider.

### Step 3: Format Configuration

```bash
terraform fmt -recursive
```

**Purpose**: Ensures code follows Terraform style conventions.

### Step 4: Validate Configuration

```bash
terraform validate
```

**Expected output**: `Success! The configuration is valid.`

### Step 5: Review the Plan

```bash
terraform plan
```

**Expected resources**:
- 1 aws_vpc
- 1 aws_internet_gateway
- 3 aws_subnet (one per AZ)
- 1 aws_route_table
- 3 aws_route_table_association

**Critical**: Review the plan carefully before applying:
- ✓ VPC CIDR is 10.10.0.0/16
- ✓ Subnets have correct CIDRs (10.10.1.0/24, 10.10.3.0/24, 10.10.5.0/24)
- ✓ Subnets in correct AZs (us-east-1a, us-east-1b, us-east-1c)
- ✓ IGW is created and attached
- ✓ Route table has route to IGW (0.0.0.0/0 → IGW)

### Step 6: Apply Configuration

```bash
terraform apply
```

When prompted, type `yes` to confirm and create resources.

**Expected output**:
```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
```

### Step 7: Verify Outputs

```bash
terraform output
```

**Expected outputs**:
- `vpc_id`: VPC resource ID
- `vpc_name`: "cmtr-5bc36296-01-vpc"
- `internet_gateway_id`: IGW resource ID
- `internet_gateway_name`: "cmtr-5bc36296-01-igw"
- `public_subnet_ids`: List of 3 subnet IDs
- `public_subnet_info`: Detailed subnet information
- `public_route_table_id`: Route table resource ID
- `public_route_table_name`: "cmtr-5bc36296-01-rt"
- `network_summary`: Complete infrastructure summary

### Step 8: Verify in AWS Console

1. Open AWS Console: https://060795923109.signin.aws.amazon.com/console?region=us-east-1
2. Sign in with:
   - Username: cmtr-5bc36296
   - Password: Ll3&0880FDdQIwaD
3. Navigate to **VPC Dashboard**
4. Verify:
   - ✓ VPC "cmtr-5bc36296-01-vpc" exists with CIDR 10.10.0.0/16
   - ✓ Internet Gateway "cmtr-5bc36296-01-igw" is attached to VPC
   - ✓ Three public subnets exist:
     - cmtr-5bc36296-01-subnet-public-a (10.10.1.0/24, us-east-1a)
     - cmtr-5bc36296-01-subnet-public-b (10.10.3.0/24, us-east-1b)
     - cmtr-5bc36296-01-subnet-public-c (10.10.5.0/24, us-east-1c)
   - ✓ Route table "cmtr-5bc36296-01-rt" is created
   - ✓ Route table has route: 0.0.0.0/0 → IGW

### Step 9: Check Code Quality

```bash
# Verify formatting
terraform fmt -check -recursive

# Expected: No output (files are properly formatted)
```

### Step 10: Final Verification Checklist

- [ ] All Terraform commands executed successfully
- [ ] terraform plan shows correct resource count (8 resources)
- [ ] terraform apply completed without errors
- [ ] All outputs display correct names and values
- [ ] AWS Console shows all resources with correct configuration
- [ ] Subnets are in correct AZs
- [ ] Route table is associated with all subnets
- [ ] IGW is attached to VPC

## Preparing for Task Verification

### Create Git Repository

```bash
# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "feat: Create AWS network infrastructure with Terraform

- VPC: cmtr-5bc36296-01-vpc (10.10.0.0/16)
- Public subnets in 3 AZs with correct CIDR blocks
- Internet Gateway: cmtr-5bc36296-01-igw
- Route table: cmtr-5bc36296-01-rt"

# Set up remote (if using GitHub, GitLab, etc.)
# git remote add origin <repository-url>
# git push -u origin main
```

### Prepare for Verification

1. **Get your repository URL** in format:
   ```
   https://<username>:<deploy_token>@<repository-url>.git
   ```

2. **Have ready**:
   - Repository HTTPS URL with deploy token
   - AWS credentials (already provided)
   - All Terraform files in repository

3. **Verification will**:
   - Clone your repository
   - Run terraform init
   - Run terraform plan
   - Run terraform apply
   - Verify all resources are created correctly
   - Check resource names match task requirements
   - Verify routing configuration
   - Validate subnet placement in AZs

## Troubleshooting During Execution

| Issue | Solution |
|-------|----------|
| AWS credentials not recognized | Set environment variables or run `aws configure` |
| Terraform version too old | Update to >= 1.5.7 from terraform.io/downloads |
| CIDR block validation error | Verify terraform.tfvars has correct CIDR notation |
| Port/permission errors | Check security group rules in AWS Console |
| Subnet in wrong AZ | Verify `availability_zones` and `public_subnet_names` alignment in terraform.tfvars |

## Resource Cleanup

If you need to start over or clean up after verification:

```bash
terraform destroy
```

When prompted, type `yes` to confirm deletion of all resources.

**Note**: All resources will be automatically deleted when the 2.5-hour session expires.

## References

- [Terraform Documentation](https://www.terraform.io/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [AWS Provider for Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform AWS VPC Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)

## Important Reminders

⚠️ **Time Limit**: Complete verification within 2.5 hours
⚠️ **Credentials**: Keep temporary AWS credentials secure
⚠️ **Resource Names**: Must match exactly:
  - VPC: cmtr-5bc36296-01-vpc
  - Subnets: cmtr-5bc36296-01-subnet-public-a/b/c
  - IGW: cmtr-5bc36296-01-igw
  - Route Table: cmtr-5bc36296-01-rt

## Success Criteria

Your task is complete when:

✅ terraform plan shows all 8 resources  
✅ terraform apply completes successfully  
✅ All resources visible in AWS Console  
✅ Resource names match task requirements exactly  
✅ Subnets in correct AZs with correct CIDR blocks  
✅ IGW attached to VPC  
✅ Route table configured with IGW route  
✅ Verification button shows 100% pass rate  

Good luck! 🚀
