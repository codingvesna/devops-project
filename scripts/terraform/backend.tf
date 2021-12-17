terraform {
  backend "s3" {
    bucket = "devops-project-v1"
    key    = "terraform/state"
    region = "eu-central-1"
  }
}