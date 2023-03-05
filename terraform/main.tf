terraform {
     required_version = ">= 0.12.24"
     backend "s3" {
          bucket = s3-filetype-terraform-backend
          key = terraform.tfstate
          region = eu-west-2
     }
}
provider "aws" {
     region = "eu-west-2"
     access_key  = "AKIA2XFS2DQ2YVDECIEA"
     secret_key = "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"
}

# Creating Lambda IAM resource
resource "aws_iam_role" "lambda_iam" {
  name = "filetype_lambda_function_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "revoke_keys_role_policy" {
  name = "filetype_lambda_function_policy"
  role = aws_iam_role.lambda_iam.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Creating Lambda function 
module "lambda_function_container_image" {
  source = "terraform-aws-modules/lambda/aws"
  attach_policy = true
  #policy = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  policy = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  function_name   = var.lambda_function_name
  create_package  = false
  image_uri       = "736961895477.dkr.ecr.eu-west-2.amazonaws.com/lambda-function:${local.docker_image_tag}"
  package_type    = "Image"
  environment_variables = {      
      email_password  = var.email_password
      email_receiver  = var.email_receiver
      email_sender    = var.email_sender
      }
}


# Adding S3 bucket as trigger to my lambda and giving the permissions
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = var.s3_bucket_name
  lambda_function {
    lambda_function_arn = "arn:aws:lambda:eu-west-2:736961895477:function:terraform-lambda-01"
    events              = ["s3:ObjectCreated:*"]

  }
}

resource "aws_lambda_permission" "test" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = "terraform-lambda-01"
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::s3-filetype-trigger"
}

