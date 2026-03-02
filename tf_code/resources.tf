data "aws_iam_policy" "existing" {
  name = "cmtr-5bc36296-iam-policy"
}

resource "aws_iam_policy" "imported" {
  name        = data.aws_iam_policy.existing.name
  description = data.aws_iam_policy.existing.description
  path        = data.aws_iam_policy.existing.path
  policy      = data.aws_iam_policy.existing.policy
  tags        = data.aws_iam_policy.existing.tags
}
