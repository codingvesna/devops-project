terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

# Variables

variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    eu-west-1 = "ami-08edbb0e85d6a0a07"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "terraform1"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "terraform1.pub"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

# s3 bucket - store terraform state

resource "aws_s3_bucket" "s3devopsproject" {
  bucket = "s3devopsproject"

  tags = {
    Name = "s3 devops project"
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "allow_access_bp" {
  bucket = aws_s3_bucket.s3devopsproject.bucket
  policy = data.aws_iam_policy_document.allow_access_bp.json
}

data "aws_iam_policy_document" "allow_access_bp" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      # "arn:aws:s3:::aws_s3_bucket.s3_devops_project.bucket"
      aws_s3_bucket.s3devopsproject.arn
    ]
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]
    resources = [
      "${aws_s3_bucket.s3devopsproject.arn}/terraform/state"
      #  "arn:aws:s3:::aws_s3_bucket.s3_devops_project.bucket/terraform/state"
    ]

  }

}

resource "aws_s3_bucket_public_access_block" "p_access" {
  bucket = aws_s3_bucket.s3devopsproject.bucket

  block_public_acls   = true
  block_public_policy = true

}

resource "aws_key_pair" "devops_project" {
  key_name   = "devops"
  public_key = file("${var.PATH_TO_PUBLIC_KEY}")
}

resource "aws_security_group" "devops_project" {
  name        = "devops_project_sg"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_project" {
  ami                         = lookup(var.AMIS, var.AWS_REGION)
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.devops_project.key_name
  user_data                   = file("update.sh")
  security_groups             = [aws_security_group.devops_project.name]
  associate_public_ip_address = true

  tags = {
    Name = "DevOpsProject"
  }



  provisioner "remote-exec" {
    inline = [
      "echo 'SSH IS READY'"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${var.PATH_TO_PRIVATE_KEY}")
  }



  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.devops_project.public_ip}, --private-key ${var.PATH_TO_PRIVATE_KEY} config.yml"
  }

}