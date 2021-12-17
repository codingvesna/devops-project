#!/bin/bash

# update
sudo apt-get update

# install packages
sudo apt-get install -y gnupg software-properties-common curl

# add the HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# add the official HashiCorp Linux repository.
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# update to add the repository

# install Terraform
sudo apt-get install terraform -y

# verify
terraform -help