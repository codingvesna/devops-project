terraform {
  backend "s3" {
    bucket = "s3devopsproject"
    key    = "terraform/state"
    region = "eu-west-1"
  }
}