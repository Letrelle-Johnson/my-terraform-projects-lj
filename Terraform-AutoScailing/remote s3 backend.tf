#remote s3 backend.tf

terraform {
  backend "s3" {
    bucket         = "myterraform-state-bucket2025-lj" # Your S3 bucket name
    key            = "myterraformdbkey.tfstate"        # Your state file path
    region         = "us-east-1"                       # AWS region
    encrypt        = true                             # Enable state encryption in S3
    dynamodb_table = "myterraform-lock-table2025-lj"   # Table used for state locking
  }
}