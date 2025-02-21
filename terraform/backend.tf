terraform {
  required_version = ">= 1.0" 
  backend "s3" {
    bucket         = "object-detection-app-bucket"
    key            = "state-file"
    region         = "eu-west-2"
    dynamodb_table = "dydb-state-locking-mlops"
    encrypt        = true
  }
}
