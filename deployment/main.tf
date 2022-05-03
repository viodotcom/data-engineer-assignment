terraform {
  required_version = ">= 1.1, < 1.2"

  backend "local" { }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4, < 5"
    }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "eu-west-1"
  s3_force_path_style         = true  
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localstack:4566"
    cloudformation = "http://localstack:4566"
    cloudwatch     = "http://localstack:4566"
    dynamodb       = "http://localstack:4566"
    es             = "http://localstack:4566"
    firehose       = "http://localstack:4566"
    iam            = "http://localstack:4566"
    kinesis        = "http://localstack:4566"
    lambda         = "http://localstack:4566"
    route53        = "http://localstack:4566"
    redshift       = "http://localstack:4566"
    s3             = "http://localstack:4566"
    secretsmanager = "http://localstack:4566"
    ses            = "http://localstack:4566"
    sns            = "http://localstack:4566"
    sqs            = "http://localstack:4566"
    ssm            = "http://localstack:4566"
    stepfunctions  = "http://localstack:4566"
    sts            = "http://localstack:4566"
  }
}

resource "aws_s3_bucket" "test" {
  bucket = "test"
}

resource "aws_lambda_function" "test" {
  function_name    = "test"
  role             = "arn:aws:iam::000000000000:role/test"
  filename         = "${path.module}/test.zip"
  source_code_hash = filebase64sha256("${path.module}/test.zip")
  handler          = "test.handler"
  runtime          = "python3.7"

  environment {
    variables = {
      BUCKET = aws_s3_bucket.test.id
    }
  }
}
