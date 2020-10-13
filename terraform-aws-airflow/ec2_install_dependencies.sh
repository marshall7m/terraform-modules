#!/bin/bash
sudo su - ec2-user
#update installed packages and package cache
sudo yum update -y

##Docker##

#install the most recent Docker Community Edition package
sudo yum install docker -y
#start docker service
sudo service docker start
#allows user to start docker without sudo
sudo usermod -a -G docker ec2-user
#authenticate docker with ECR repo
echo "Authenticating Docker with ECR repo"
aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ecr_repo_url}