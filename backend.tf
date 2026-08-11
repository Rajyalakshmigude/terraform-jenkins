terraform {
  backend "s3" {

    bucket = "terraform-tf-state-11-08-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
    
  }
}