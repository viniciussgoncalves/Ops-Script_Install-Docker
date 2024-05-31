#!/bin/bash

################################################################################
# Script Name   : Docker Setup
# Description   : Script to install Docker
# Version       : 2.0
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
# Script Name   : Docker Setup
# Description   : Script to install Docker
# Version       : 2.0
# Author        : Vinicius Gonçalves
################################################################################"
  echo -e "\e[0m"
}

# Function to check if Docker is installed
check_docker_installed() {
  if command -v docker &> /dev/null; then
    echo -e "\e[32mDocker is already installed:\e[0m"
    docker --version
    exit 0
  fi
}

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

# Function to identify the distribution
identify_distribution() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
  else
    DISTRO=$(uname -s)
  fi
}

# Function to get the distribution color
get_distro_color() {
  case "$DISTRO" in
    ubuntu)
      echo -e "\e[38;5;208m"  # Orange
      ;;
    debian)
      echo -e "\e[31m"  # Red
      ;;
    raspbian)
      echo -e "\e[31m"  # Red
      ;;
    centos)
      echo -e "\e[34m"  # Blue
      ;;
    fedora)
      echo -e "\e[34m"  # Blue
      ;;
    rhel)
      echo -e "\e[31m"  # Red
      ;;
    sles)
      echo -e "\e[32m"  # Green
      ;;
    *)
      echo -e "\e[37m"  # Default to white
      ;;
  esac
}

# Function to show a spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    echo -n " "
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    echo "    "
}

# Main script execution
main() {
  print_header

  # Request sudo permissions at the beginning of the script
  sudo -v

  # Capture the original user
  ORIGINAL_USER=$(logname)

  # Identify the distribution
  identify_distribution

  # Get the distribution color
  DISTRO_COLOR=$(get_distro_color)

  # Print the distribution name
  echo -e "\n\nInstalling Docker on ${DISTRO_COLOR}${DISTRO}\e[0m distribution\n\n"

  # Check if Docker is already installed
  check_docker_installed

  # Create and clear the log file
  log_file="docker_install.log"
  > "$log_file"

  # Update system packages
  print_start "Package update"
  {
    if [[ "$DISTRO" == "centos" || "$DISTRO" == "rhel" || "$DISTRO" == "fedora" || "$DISTRO" == "sles" ]]; then
      sudo yum update -y
    else
      sudo apt-get update -y
    fi
  } &>> "$log_file" &
  spinner $!
  check_command "Package update"
  print_success "Package update completed successfully."

  # Install dependencies
  print_start "Dependency installation"
  {
    if [[ "$DISTRO" == "centos" || "$DISTRO" == "rhel" || "$DISTRO" == "fedora" ]]; then
      sudo yum install -y yum-utils
    elif [[ "$DISTRO" == "sles" ]]; then
      sudo zypper install -y zypper
    else
      sudo apt-get install -y ca-certificates curl
    fi
  } &>> "$log_file" &
  spinner $!
  check_command "Dependency installation"
  print_success "Dependency installation completed successfully."

  # Add Docker's official GPG key and repository based on the distribution
  case "$DISTRO" in
    ubuntu)
      print_start "Add Docker GPG key"
      {
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker GPG key"
      print_success "Docker GPG key added successfully."
      
      print_start "Add Docker repository"
      {
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker repository"
      print_success "Docker repository added successfully."
      ;;
    
    debian)
      print_start "Add Docker GPG key"
      {
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker GPG key"
      print_success "Docker GPG key added successfully."
      
      print_start "Add Docker repository"
      {
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker repository"
      print_success "Docker repository added successfully."
      ;;
    
    raspbian)
      print_start "Add Docker GPG key"
      {
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/raspbian/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker GPG key"
      print_success "Docker GPG key added successfully."
      
      print_start "Add Docker repository"
      {
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/raspbian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker repository"
      print_success "Docker repository added successfully."
      ;;
    
    centos)
      print_start "Add Docker repository"
      {
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker repository"
      print_success "Docker repository added successfully."
      ;;
    
    fedora)
      print_start "Add Docker repository"
      {
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker repository"
      print_success "Docker repository added successfully."
      ;;
    
    rhel)
      print_start "Add Docker repository"
      {
        sudo yum-config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker repository"
      print_success "Docker repository added successfully."
      ;;
    
    sles)
      print_start "Add Docker repository"
      {
        sudo zypper addrepo https://download.docker.com/linux/sles/docker-ce.repo
      } &>> "$log_file" &
      spinner $!
      check_command "Add Docker repository"
      print_success "Docker repository added successfully."
      ;;
    
    *)
      echo -e "\e[31mUnsupported distribution: $DISTRO\e[0m"
      exit 1
      ;;
  esac

  # Update the package index again
  print_start "Update package index"
  {
    if [[ "$DISTRO" == "centos" || "$DISTRO" == "rhel" || "$DISTRO" == "fedora" || "$DISTRO" == "sles" ]]; then
      sudo yum update -y
    else
      sudo apt-get update -y
    fi
  } &>> "$log_file" &
  spinner $!
  check_command "Update package index"
  print_success "Package index updated successfully."

  # Install Docker packages
  print_start "Docker packages installation"
  {
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  } &>> "$log_file" &
  spinner $!
  check_command "Docker packages installation"
  print_success "Docker packages installed successfully."

  # Enable and start Docker service
  print_start "Enable and start Docker service"
  {
    sudo systemctl enable docker
    sudo systemctl start docker
  } &>> "$log_file" &
  spinner $!
  check_command "Enable and start Docker service"
  print_success "Docker service enabled and started successfully."

  # Add current user to the Docker group
  print_start "Add user to Docker group"
  {
    sudo usermod -aG docker "$ORIGINAL_USER"
  } &>> "$log_file" &
  spinner $!
  check_command "Add user to Docker group"
  print_success "User added to Docker group successfully."

  # End
  print_start "Finalizing installation"
  print_success "Installation process completed."
  echo -e "\n\n\e[33mWARNING: Please log out and log back in as $ORIGINAL_USER for the changes to take effect.\e[0m\n"  # Yellow text for warning message
  echo "Please log out and log back in as $ORIGINAL_USER for the changes to take effect." >> "$log_file"
}

# Execute the main function
main "$@"