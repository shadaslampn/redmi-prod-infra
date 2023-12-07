terraform {
  backend "s3" {
    bucket = "terraform.redmi-prod.shadops.com"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
