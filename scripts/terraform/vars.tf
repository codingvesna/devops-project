variable "aws_region" {
  default = "eu-central-1"
}

variable "instance_type" {}

variable "ami" {
  type = map(string)
  default = {
    eu-central-1 = "ami-0d527b8c289b4af7f"
  }
}
variable "PATH_TO_PRIVATE_KEY" {}

variable "PATH_TO_PUBLIC_KEY" {}