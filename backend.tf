

resource "aws_s3_bucket" "backend" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.backend.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock-table"
  billing_mode = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
  }
}

