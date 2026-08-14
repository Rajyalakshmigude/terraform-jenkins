terraform {
  backend "s3" {

    bucket = "terraform-tf-state-14-08"
    key = "terraform.tfstate"
    region = "ap-south-2"
    dynamodb_table = "terraform-lock"
    
  }
}
