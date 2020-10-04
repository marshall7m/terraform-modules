#!/bin/bash

#update installed packages and package cache
sudo yum update -y

#install the most recent Docker Community Edition package
echo "Installing Docker"
sudo amazon-linux-extras install docker
echo "Starting Docker"
sudo service docker start
#allows user to start docker without sudo
sudo usermod -a -G docker ec2-user
#authenticate docker with ECR repo
echo "Authenticating Docker with ECR repo"
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ecr_repo_url}