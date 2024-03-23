data aws_iam_policy_document lambda_assume_role {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource aws_iam_role lambda_role {
  name               = "lambda-role-market_data_download"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data aws_iam_policy_document lambda_s3 {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::bucket/*"
    ]
  }
}

resource aws_iam_policy lambda_s3 {
  name        = "lambda-s3-permissions-market_data_download"
  description = "Contains S3 put permission for lambda"
  policy      = data.aws_iam_policy_document.lambda_s3.json
}

resource aws_iam_role_policy_attachment lambda_s3 {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3.arn
}

resource "aws_lambda_function" "executable" {
  function_name = "market_data_download"
  image_uri     = "${aws_ecr_repository.api_repository.repository_url}:${vars.image_tag}"
  package_type  = "Image"
  role          = aws_iam_role.lambda_role.arn
}
