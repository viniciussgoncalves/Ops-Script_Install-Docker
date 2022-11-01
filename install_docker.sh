#!/bin/bash

###################################################################
# Script Name   : Script Install Docker                                                                                             
# Description	: Script to install Docker                                                                             
# Version       : 1.0                                                                                           
# Author       	: Vinicius Gonçalves                                           
###################################################################

# UPDATE
sudo apt-get update -y &&

# INSTALL DOCKER ENGINE
sudo apt-get install ca-certificates curl gnupg lsb-release -y &&
sudo mkdir -p /etc/apt/keyrings &&
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
sudo apt-get update -y && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y &&

# END
echo "Complete installation!"