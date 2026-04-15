resource "aws_iam_policy" "custom_policy" {
  name = "custom_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })

  lifecycle {
    ignore_changes = all
  }
}
