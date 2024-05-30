# Docker Install Script

## Description

This script automates the installation of Docker on an Ubuntu system. It performs the following steps:

1. Checks if Docker is already installed. If installed, it prints the installed version and exits.
2. Updates the system packages.
3. Installs necessary dependencies.
4. Adds Docker's official GPG key.
5. Adds the Docker repository to the system's Apt sources.
6. Updates the package index again.
7. Installs Docker packages.
8. Enables and starts the Docker service.
9. Adds the current user to the Docker group to allow Docker commands without `sudo`.

## Prerequisites

- An Ubuntu-based system.
- `sudo` privileges.

## Usage

1. **Download and run the script:**

   ```sh
   wget https://raw.githubusercontent.com/viniciussgoncalves/Ops-Script_Install_Docker/main/docker_install.sh && bash docker_install.sh
   ```

   The script will check if Docker is already installed. If it is, the script will print the installed version and exit. If not, it will proceed with the installation.

## Script Details

The script includes the following main functions:

### print_header

Prints an ASCII art header along with script information.

### check_docker_installed

Checks if Docker is already installed. If it is, prints the installed version and exits the script.

### check_command

Checks the status of the last executed command and exits the script if the command failed.

### print_success

Prints success messages in green.

### print_start

Prints the start message for each step in blue.

## Example Output

```plaintext
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

###################################################################
# Script Name   : Script Install Docker                           #
# Description   : Script to install Docker                        #
# Version       : 1.1                                             #
# Author        : Vinicius Gonçalves                              #
###################################################################

Starting: Package update
Package update completed successfully.
Starting: Dependency installation
Dependency installation completed successfully.
Starting: Add Docker GPG key
Docker GPG key added successfully.
Starting: Add Docker repository
Docker repository added successfully.
Starting: Update package index
Package index updated successfully.
Starting: Docker packages installation
Docker packages installed successfully.
Starting: Enable and start Docker service
Docker service enabled and started successfully.
Starting: Add user to Docker group
User added to Docker group successfully.
Starting: Finalizing installation
Installation complete! Please log out and log back in for the changes to take effect.
Installation process completed.
```
