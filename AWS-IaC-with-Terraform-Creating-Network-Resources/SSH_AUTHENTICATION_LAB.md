# SSH Authentication Lab - Implementation Guide

## Overview

This lab establishes secure SSH authentication mechanisms for AWS EC2 instances using Terraform. The infrastructure includes SSH key pair management, security group configuration, and EC2 instance provisioning.

## Files Created/Modified

### 1. **variables.tf** (Modified)
- Added `ssh_key` variable
- Type: `string`
- Description: "Provides custom public SSH key."
- Marked as sensitive to prevent exposure in logs
- **Note**: No default value - must be provided via environment variable

### 2. **ssh.tf** (New)
Creates the SSH key pair resource:
- Resource: `aws_key_pair.cmtr-5bc36296-keypair`
- Key name: `cmtr-5bc36296-keypair`
- Public key source: `var.ssh_key` variable
- Tags applied for tracking and management

### 3. **ec2.tf** (New)
Creates two key resources:

#### Security Group: `aws_security_group.cmtr-5bc36296-sg`
- Allows inbound SSH (port 22) from anywhere
- Allows all outbound traffic
- Tags applied for organization

#### EC2 Instance: `aws_instance.cmtr-5bc36296-ec2`
- AMI: Amazon Linux 2 (ami-0c55b159cbfafe1f0 for us-east-1)
- Instance type: t2.micro
- Key pair: References `cmtr-5bc36296-keypair`
- Security group: References `cmtr-5bc36296-sg`
- Subnet: Uses first public subnet from VPC (aws_subnet.public[0])
- Public IP: Enabled for SSH access
- Tags applied with Project and ID

### 4. **outputs.tf** (Modified)
Added comprehensive outputs:
- `key_pair_id` - Name of the SSH key pair
- `key_pair_fingerprint` - Fingerprint for verification
- `security_group_id` - ID of the security group
- `security_group_name` - Name of the security group
- `ec2_instance_id` - ID of the EC2 instance
- `ec2_instance_public_ip` - IP address for SSH access
- `ec2_instance_public_dns` - DNS name
- `ec2_instance_private_ip` - Private IP
- `ec2_instance_key_name` - Key pair name
- `ssh_access_summary` - Complete SSH access information

## Prerequisites

### 1. Generate SSH Key Pair
On your local machine, generate a new SSH key pair:

```bash
# Using RSA (4096 bits recommended)
ssh-keygen -t rsa -b 4096 -f ~/cmtr-5bc36296-key -N ""

# Or using ECDSA (256 bits)
ssh-keygen -t ecdsa -b 256 -f ~/cmtr-5bc36296-key -N ""

# Or using Ed25519 (modern, recommended)
ssh-keygen -t ed25519 -f ~/cmtr-5bc36296-key -N ""
```

### 2. Extract Public Key
Get the public key in proper format:

```bash
# Display the public key
cat ~/.ssh/cmtr-5bc36296-key.pub

# Or copy to clipboard (on macOS)
cat ~/.ssh/cmtr-5bc36296-key.pub | pbcopy

# Or copy to clipboard (on Linux)
cat ~/.ssh/cmtr-5bc36296-key.pub | xclip -selection clipboard
```

### 3. Set Environment Variable
Export the public key as an environment variable:

```bash
# Option 1: Direct
export TF_VAR_ssh_key="ssh-rsa AAAA... your-public-key-content-here"

# Option 2: From file
export TF_VAR_ssh_key="$(cat ~/.ssh/cmtr-5bc36296-key.pub)"

# Verify it's set
echo $TF_VAR_ssh_key
```

## Execution Steps

### 1. Initialize Terraform
```bash
cd "c:\Users\OleksandrSydor\!!Code\Cloud-Mentor\AWS-IaC-with-Terraform-Creating-Network-Resources"

terraform init
```

### 2. Format Configuration
```bash
terraform fmt -recursive
```

### 3. Validate Configuration
```bash
terraform validate
```

### 4. Review Plan
```bash
terraform plan

# Expected: Should show resources to be created for SSH key pair, security group, and EC2 instance
```

### 5. Apply Configuration
```bash
terraform apply

# Type 'yes' when prompted
```

### 6. Get Output Information
```bash
terraform output

# Will show:
# - key_pair_id
# - key_pair_fingerprint
# - security_group_id
# - ec2_instance_public_ip
# - ssh_command example
```

## SSH Access

After successful deployment, connect to your EC2 instance:

### 1. Verify Private Key Permissions
```bash
# Unix/Linux/macOS
chmod 600 ~/.ssh/cmtr-5bc36296-key

# Windows (using Git Bash or WSL)
chmod 600 ~/.ssh/cmtr-5bc36296-key
```

### 2. SSH Connection
```bash
# Get the public IP from terraform output
PUBLIC_IP=$(terraform output -raw ec2_instance_public_ip)

# Connect to the instance
ssh -i ~/.ssh/cmtr-5bc36296-key ec2-user@$PUBLIC_IP

# Or use the SSH command from output
ssh -i ~/.ssh/cmtr-5bc36296-key ec2-user@<public-ip-address>
```

### 3. Troubleshooting SSH Connection
```bash
# Test SSH connectivity with verbose output
ssh -v -i ~/.ssh/cmtr-5bc36296-key ec2-user@<public-ip> 

# Check if the instance is running
aws ec2 describe-instances --instance-ids $(terraform output -raw ec2_instance_id) \
  --region us-east-1

# Check security group rules
aws ec2 describe-security-groups --group-ids $(terraform output -raw security_group_id) \
  --region us-east-1
```

## Resource Dependencies

The configuration respects the following dependency chain:
1. **VPC and Subnets** (from vpc.tf) - Created first
2. **SSH Key Pair** (ssh.tf) - Independent, but required for EC2
3. **Security Group** (ec2.tf) - Independent vpc resource
4. **EC2 Instance** (ec2.tf) - Depends on: key pair, security group, subnet

## Tags Applied

All resources include proper tags for organization:
- **Project**: epam-tf-lab
- **ID**: cmtr-5bc36296
- **Name**: Resource-specific name

## Security Considerations

### ✅ Best Practices Implemented
- Public key provided via environment variable (not hardcoded)
- Private key never stored/committed to repository
- Security group restricts access to necessary ports only
- EC2 instance in public subnet with public IP enabled for direct SSH
- Tags enable resource tracking and management

### ⚠️ Important Security Notes
1. **Never commit private keys** to version control
2. **Protect SSH key permissions**: `chmod 600 private-key`
3. **Limit SSH access**: Consider restricting source IP ranges in security group
4. **Rotate keys regularly**: Regenerate and update periodically
5. **Monitor access**: Use CloudTrail and VPC Flow Logs

## Cleanup

When finished with the lab, destroy all resources:

```bash
terraform destroy

# Type 'yes' when prompted

# Verify resources are deleted
terraform show
```

## Verification Checklist

- [ ] SSH key pair generated (private and public keys)
- [ ] Public key exported to `TF_VAR_ssh_key` environment variable
- [ ] `terraform init` completes successfully
- [ ] `terraform fmt` runs without errors
- [ ] `terraform validate` shows configuration valid
- [ ] `terraform plan` lists expected resources (key pair, security group, EC2)
- [ ] `terraform apply` completes successfully
- [ ] Outputs display SSH key pair ID and EC2 public IP
- [ ] AWS Console shows key pair created
- [ ] AWS Console shows security group created
- [ ] AWS Console shows EC2 instance running
- [ ] SSH connection successful: `ssh -i <key> ec2-user@<ip>`
- [ ] Tags visible on all resources in AWS Console
- [ ] No public SSH key found in any .tf files (only variable reference)

## References

- [SSH-keygen Documentation](https://man.openbsd.org/ssh-keygen)
- [Terraform aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
- [Terraform aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [AWS Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)
- [EC2 Key Pairs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

## Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| `TF_VAR_ssh_key not recognized` | Verify variable is exported: `echo $TF_VAR_ssh_key` |
| `Invalid public key format` | Ensure key starts with `ssh-rsa` or `ssh-ed25519` |
| `SSH connection refused` | Wait 30-60 seconds after apply for instance initialization |
| `Permission denied (publickey)` | Check private key permissions: `chmod 600 key-file` |
| `No route to host` | Verify security group allows port 22 and EC2 has public IP |
| `Host key verification failed` | First connection normal - type `yes` to accept |

---

**Lab Status**: ✅ Ready for Execution  
**All Files**: ✅ Created and Configured  
**AWS Resources**: Ready to be provisioned  
**Verification**: Follow checklist steps above
