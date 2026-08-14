terraform {
  backend "s3" {

    bucket = "terraform-tf-state-14-08-2026-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
    
  }
}
