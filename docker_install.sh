#!/bin/bash

################################################################################
# Script Name   : Script Install Docker
# Description   : Script to install Docker
# Version       : 1.1
# Author        : Vinicius Gonçalves
################################################################################

# Function to print ASCII art and script information
print_header() {
  echo -e "\e[34m"
  cat << "EOF"
                        .="=.
                      _/.-.-.\_     _
                     ( ( o o ) )    ))
                      |/  "  \|    //
      .-------.        \'---'/    //
     _|~~ ~~  |_       /`"""`\\  ((
   =(_|_______|_)=    / /_,_\ \\  \\
     |:::::::::|      \_\\_'__/ \  ))
     |:::::::[]|       /`  /`~\  |//
     |o=======.|      /   /    \  /
     `"""""""""`  ,--`,--'\/\    /
                   '-- "--'  '--'
EOF
  echo -e "\e[32m
################################################################################
# Script Name   : Script Install Docker
# Description   : Script to install Docker
# Version       : 1.1
# Author        : Vinicius Gonçalves
################################################################################"
}

print_header

# Request sudo permissions at the beginning of the script
sudo -v

# Capture the original user
ORIGINAL_USER=$(logname)

# Function to check if Docker is installed
check_docker_installed() {
  if command -v docker &> /dev/null; then
    echo -e "\e[32mDocker is already installed:\e[0m"
    docker --version
    exit 0
  fi
}

# Check if Docker is already installed
check_docker_installed

# Function to check the status of the last executed command
check_command() {
  if [ $? -ne 0 ]; then
    echo -e "\e[31mError: $1 failed.\e[0m"  # Red text for errors
    echo "Error: $1 failed." >> docker_install.log
    exit 1
  fi
}

# Function to print success messages in green
print_success() {
  echo -e "\e[32m$1\e[0m"  # Green text for success
  echo "$1" >> docker_install.log
}

# Function to print start messages in blue
print_start() {
  echo -e "\e[34mStarting: $1\e[0m"  # Blue text for steps starting
  echo "Starting: $1" >> docker_install.log
}

# Create and clear the log file
log_file="docker_install.log"
> $log_file

# Update system packages
print_start "Package update"
{
  sudo apt-get update -y
} &>> $log_file
check_command "Package update"
print_success "Package update completed successfully."

# Install dependencies
print_start "Dependency installation"
{
  sudo apt-get install -y ca-certificates curl
} &>> $log_file
check_command "Dependency installation"
print_success "Dependency installation completed successfully."

# Add Docker's official GPG key
print_start "Add Docker GPG key"
{
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
} &>> $log_file
check_command "Add Docker GPG key"
print_success "Docker GPG key added successfully."

# Add the Docker repository to Apt sources
print_start "Add Docker repository"
{
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
} &>> $log_file
check_command "Add Docker repository"
print_success "Docker repository added successfully."

# Update the package index again
print_start "Update package index"
{
  sudo apt-get update -y
} &>> $log_file
check_command "Update package index"
print_success "Package index updated successfully."

# Install Docker packages
print_start "Docker packages installation"
{
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
} &>> $log_file
check_command "Docker packages installation"
print_success "Docker packages installed successfully."

# Enable and start Docker service
print_start "Enable and start Docker service"
{
  sudo systemctl enable docker
  sudo systemctl start docker
} &>> $log_file
check_command "Enable and start Docker service"
print_success "Docker service enabled and started successfully."

# Add current user to the Docker group
print_start "Add user to Docker group"
{
  sudo usermod -aG docker $USER
} &>> $log_file
check_command "Add user to Docker group"
print_success "User added to Docker group successfully."

# End
print_start "Finalizing installation"
echo -e "\e[32mInstallation complete! Please log out and log back in as $ORIGINAL_USER for the changes to take effect.\e[0m"  # Green text for final message
echo "Installation complete! Please log out and log back in as $ORIGINAL_USER for the changes to take effect." >> $log_file
print_success "Installation process completed."