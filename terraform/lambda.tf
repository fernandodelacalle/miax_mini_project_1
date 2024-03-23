resource "aws_iam_role" "lambda_role" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_dynamo" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# resource "aws_cloudwatch_log_group" "hello_world" {
#   name = "/aws/lambda/${aws_lambda_function.executable.function_name}"
#   retention_in_days = 30
# }





resource "aws_lambda_function" "executable" {
  function_name = "market_data_download"
  image_uri     = "${aws_ecr_repository.api_repository.repository_url}:${var.image_tag}"
  package_type  = "Image"
  role          = aws_iam_role.lambda_role.arn
  memory_size = 512
  timeout = 300

  lifecycle {
    ignore_changes = [
      environment,
    ]
  }
}


# Create our schedule
# Trigger our lambda based on the schedule
resource "aws_cloudwatch_event_rule" "lambda_every_5_minutes" {
  name                = "market_data_download-lambda-every-5-minutes"
  description         = "Every 5 minutes"
  schedule_expression = "cron(0/5 * * * ? *)"
}
resource "aws_cloudwatch_event_target" "trigger_lambda_on_schedule" {
  rule      = aws_cloudwatch_event_rule.lambda_every_5_minutes.name
  target_id = "lambda"
  arn       = aws_lambda_function.executable.arn
}
resource "aws_lambda_permission" "allow_cloudwatch_to_call_split_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_every_5_minutes.arn
}
