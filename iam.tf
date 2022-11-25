# configured aws provider with proper credentials
provider "aws" {
  region    = "ap-south-1"
  access_key = ""
  secret_key = ""
  
}

# create an iam user
resource "aws_iam_user" "iam_user" {
  name = "Sam1"
}

resource "aws_iam_role" "s3_role" {
  name = "s3_iam_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}


# give the iam user programatic access
resource "aws_iam_access_key" "iam_access_key" {
  user = aws_iam_user.iam_user.name
}

# create the inline policy
data "aws_iam_policy_document" "s3_get_put_detele_policy_document" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::0bucke/*",
      "arn:aws:s3:::1buck6/*"
    ]
  }
}

# attach the policy to the user
resource "aws_iam_user_policy" "s3_get_put_detele_policy" {
  name    = "s3_get_put_detele_policy"
  user    = aws_iam_user.iam_user.name
  policy  = data.aws_iam_policy_document.s3_get_put_detele_policy_document.json
}