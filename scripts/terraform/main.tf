# key pair - requires an existing user-supplied key pair

resource "aws_key_pair" "devops-project" {
  key_name   = "devops-project-key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}



# security group - allow ssh

resource "aws_security_group" "ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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


# security group - allow http

resource "aws_security_group" "http" {
  name        = "allow-http"
  description = "open port 8080"

  ingress {
    from_port   = 8080
    to_port     = 8080
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

# security group - allow http 8081

resource "aws_security_group" "http-8081" {
  name        = "allow-http-8081"
  description = "open port 8081"

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


# ec2 instance

resource "aws_instance" "devops-project" {
  ami                         = lookup(var.ami, var.aws_region)
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.devops-project.key_name
  associate_public_ip_address = true
  user_data                   = file("update.sh")
  security_groups             = [aws_security_group.ssh.name, aws_security_group.http.name, aws_security_group.http-8081.name]

  tags = {
    Name = "devops-project"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}

# s3 bucket - store terraform state

resource "aws_s3_bucket" "remote_state" {
  bucket = "devops-project-v1"

  tags = {
    Name = "devops-project-v1"
  }
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "allow_access_bp" {
  bucket = aws_s3_bucket.remote_state.bucket
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
      # "arn:aws:s3:::aws_s3_bucket.remote_state.bucket"
      aws_s3_bucket.remote_state.arn
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
      "${aws_s3_bucket.remote_state.arn}/terraform/state"
      #  "arn:aws:s3:::aws_s3_bucket.remote_state.bucket/terraform/state"
    ]

  }

}

resource "aws_s3_bucket_public_access_block" "p_access" {
  bucket = aws_s3_bucket.remote_state.bucket

  block_public_acls   = false
  block_public_policy = false

}


# remote state