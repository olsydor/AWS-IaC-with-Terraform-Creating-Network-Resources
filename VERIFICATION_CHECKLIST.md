# Terraform Configuration Verification Checklist

Use this checklist to verify your Terraform configuration meets all requirements before submitting.

## Code Quality & Format

- [ ] All `.tf` files are properly formatted using `terraform fmt`
- [ ] No hardcoded resource names exist in resource definitions
- [ ] Resource names use variables or dynamic concatenation via locals
- [ ] All code is clean and follows Terraform conventions

## Configuration Files Structure

### versions.tf
- [ ] Contains `terraform.required_version = ">= 1.5.7"`
- [ ] Specifies AWS provider version (e.g., "~> 5.0")
- [ ] No backend configuration is defined
- [ ] Provider configuration includes region from variable

### variables.tf
- [ ] All variables have type definitions (string, list, map, bool)
- [ ] All variables have descriptions
- [ ] Descriptions are non-empty and descriptive
- [ ] Input validations present for CIDR blocks and AZs
- [ ] Default values only where appropriate
- [ ] No hardcoded values in variable defaults

### main.tf
- [ ] VPC resource created with variable CIDR block
- [ ] Internet Gateway resource created
- [ ] Public subnets created dynamically using count
- [ ] Route table created for public subnets
- [ ] Route table associations created
- [ ] All resources use locals for naming conventions
- [ ] Common tags applied to all resources
- [ ] No local-exec provisioners used
- [ ] No prevent_destroy lifecycle attributes used

### outputs.tf
- [ ] All outputs have descriptions
- [ ] Descriptions are clear and non-empty
- [ ] VPC ID output exists
- [ ] Internet Gateway ID output exists
- [ ] Public subnet IDs output exists
- [ ] Route table ID output exists
- [ ] Summary output provides overview

### terraform.tfvars
- [ ] Contains all required variable values
- [ ] CIDR blocks match task parameters
- [ ] Availability zones match task parameters
- [ ] Project name and environment are set
- [ ] DNS settings configured (usually true)

### .gitignore
- [ ] Terraform state files are ignored (*.tfstate, *.tfstate.*)
- [ ] .terraform directory is ignored
- [ ] Sensitive files are ignored
- [ ] File is present and properly configured

## Terraform Validation

Run these commands before deployment:

```bash
terraform init
```
- [ ] Initialization completes without errors
- [ ] No warning messages about configuration

```bash
terraform validate
```
- [ ] Configuration is valid
- [ ] No syntax errors reported

```bash
terraform fmt -check
```
- [ ] All files are properly formatted
- [ ] No formatting issues detected

```bash
terraform plan
```
- [ ] Plan completes successfully
- [ ] Review plan output shows:
  - [ ] 1 VPC will be created
  - [ ] 1 Internet Gateway will be created
  - [ ] N public subnets will be created (matches AZ count)
  - [ ] 1 route table will be created
  - [ ] N route table associations will be created

## AWS Resource Requirements

When reviewing `terraform plan`, verify:

### VPC
- [ ] CIDR block matches variable value
- [ ] DNS hostnames enabled
- [ ] DNS support enabled
- [ ] Proper naming using locals
- [ ] Tags applied

### Internet Gateway
- [ ] Attached to VPC
- [ ] Proper naming using locals
- [ ] Tags applied

### Public Subnets
- [ ] Count matches availability zones
- [ ] Each has unique CIDR block
- [ ] Each in different availability zone
- [ ] Automatic public IP assignment enabled
- [ ] Proper naming with sequential numbers
- [ ] Tags applied (including Type: "Public")

### Route Table
- [ ] Associated with all public subnets
- [ ] Contains route 0.0.0.0/0 → Internet Gateway
- [ ] Proper naming using locals
- [ ] Tags applied (including Type: "Public")

## Deployment Verification

After running `terraform apply`:

### AWS Console Verification
- [ ] Navigate to VPC Dashboard
- [ ] Verify VPC exists with correct CIDR
- [ ] Confirm Internet Gateway is attached to VPC
- [ ] Check public subnets exist in correct AZs
- [ ] Verify route table routes traffic to IGW
- [ ] All resources have proper tags
- [ ] Resource names follow expected pattern

### Terraform Outputs
```bash
terraform output
```
- [ ] vpc_id displays VPC ID
- [ ] vpc_cidr_block shows correct CIDR
- [ ] internet_gateway_id displays IGW ID
- [ ] public_subnet_ids shows all subnet IDs
- [ ] public_route_table_id displays route table ID
- [ ] All outputs have non-null values

### State File Check
```bash
terraform state list
```
- [ ] aws_vpc.main exists
- [ ] aws_internet_gateway.main exists
- [ ] aws_subnet.public[0], aws_subnet.public[1], etc. exist
- [ ] aws_route_table.public exists
- [ ] aws_route_table_association.public[*] entries exist

## Repository Submission

Before pushing to repository:

- [ ] All sensitive data removed from tracked files
- [ ] terraform.tfvars file reviewed (no secrets)
- [ ] .gitignore configuration is correct
- [ ] All `.tf` files are properly formatted
- [ ] Git history is clean (no sensitive commits)
- [ ] README.md is present and complete
- [ ] QUICKSTART.md is present

## Git Submission

```bash
git add .
git status
```
- [ ] Only tracked files shown (no .terraform, *.tfstate, etc.)
- [ ] All necessary .tf files included
- [ ] Documentation files included

```bash
git commit -m "feat: Create AWS network stack with Terraform"
git push origin main
```
- [ ] Push completes without errors
- [ ] Repository reflects changes

## Final Review

- [ ] All requirements from README.md are met
- [ ] No hardcoded values in configurations
- [ ] Variables properly used throughout
- [ ] Naming conventions consistent
- [ ] Tags applied to all resources
- [ ] Code is clean and formatted
- [ ] No errors or warnings during plan/apply
- [ ] Infrastructure deployed successfully to AWS

---

**Status:** ☐ Ready for Submission

Once all items are checked, your Terraform configuration is ready for verification.
