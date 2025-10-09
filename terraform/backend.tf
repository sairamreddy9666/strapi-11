terraform {
  backend "s3" {
    bucket = "sairam-strapi-bucket"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
