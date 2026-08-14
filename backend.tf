terraform {
  backend "s3" {

    bucket = "terraform-tf-state-14-08t"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
    
  }
}
