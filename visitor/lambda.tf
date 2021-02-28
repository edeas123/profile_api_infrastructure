data "aws_s3_bucket" "lambda-bucket" {
  bucket = "mybytesni-lambdas-use1"
}

data "aws_s3_bucket_object" "record-visit" {
  bucket = data.aws_s3_bucket.lambda-bucket.bucket
  key = "visitor_record_visit.zip"
}

# === /visitor POST count
resource "aws_lambda_function" "record-visit" {
  function_name     = "visitor_record_visit"
  description       = "Record visit"
  handler           = "handlers.create"
  role              = aws_iam_role.lambda-execution-role.arn
  runtime           = "python3.8"
  s3_bucket         = data.aws_s3_bucket_object.record-visit.bucket
  s3_key            = data.aws_s3_bucket_object.record-visit.key
  s3_object_version = data.aws_s3_bucket_object.record-visit.version_id

  lifecycle {
    ignore_changes = [s3_object_version]
  }
}

# === Authorize Api gateway to invoke lambda
resource "aws_lambda_permission" "record_visit" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.record-visit.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.profile.execution_arn}*/${aws_api_gateway_method.visitor-post.http_method}${aws_api_gateway_resource.visitor.path}"
}
