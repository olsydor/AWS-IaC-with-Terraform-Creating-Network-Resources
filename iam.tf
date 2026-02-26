# IAM Group
resource "aws_iam_group" "cmtr-5bc36296-iam-group" {
  name = "cmtr-5bc36296-iam-group"
}

# IAM Policy for S3 bucket access
resource "aws_iam_policy" "cmtr-5bc36296-iam-policy" {
  name        = "cmtr-5bc36296-iam-policy"
  description = "IAM policy for S3 bucket write access"
  policy      = templatefile("${path.module}/policy.json", { bucket_name = "cmtr-5bc36296-bucket-1772111858" })

  tags = {
    Project = "cmtr-5bc36296"
  }
}

# IAM Role with trust relationship for EC2
resource "aws_iam_role" "cmtr-5bc36296-iam-role" {
  name = "cmtr-5bc36296-iam-role"

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
    Project = "cmtr-5bc36296"
  }
}

# Attach IAM policy to the role
resource "aws_iam_role_policy_attachment" "cmtr-5bc36296-policy-attachment" {
  role       = aws_iam_role.cmtr-5bc36296-iam-role.name
  policy_arn = aws_iam_policy.cmtr-5bc36296-iam-policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "cmtr-5bc36296-iam-instance-profile" {
  name = "cmtr-5bc36296-iam-instance-profile"
  role = aws_iam_role.cmtr-5bc36296-iam-role.name
}
