#!/bin/bash
sudo su - ec2-user
#update installed packages and package cache
sudo yum update -y

##Docker##

#install the most recent Docker Community Edition package (linux 2)
sudo amazon-linux-extras install docker

#start docker service
sudo service docker start

#allows user to start docker without sudo
sudo usermod -a -G docker ec2-user

#install ecr credential helper to automate docker authentication with ECR
sudo amazon-linux-extras enable docker
sudo yum install amazon-ecr-credential-helper -y
sudo mkdir ~/.docker
sudo printf "{\n\t"credsStore": "ecr-login"\n}" >> ~/.docker/config.json