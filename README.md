# Docker Setup Script

## Description

This script automates the installation of Docker on various Linux distributions. It performs the following steps:

1. Checks if Docker is already installed. If installed, it prints the installed version and exits.
2. Identifies the Linux distribution.
3. Updates the system packages.
4. Installs necessary dependencies.
5. Adds Docker's official GPG key (for applicable distributions).
6. Adds the Docker repository to the system's package manager.
7. Updates the package index again.
8. Installs Docker packages.
9. Enables and starts the Docker service.
10. Adds the current user to the Docker group to allow Docker commands without `sudo`.
11. Displays a progress spinner during installation steps.

## Prerequisites

- A supported Linux distribution.
- `sudo` privileges.

## Supported Distributions

- Ubuntu
- Debian
- Raspbian
- CentOS
- Fedora
- Red Hat Enterprise Linux (RHEL)
- SUSE Linux Enterprise Server (SLES)

## Usage

1. **Download and run the script:**

   ```sh
   curl -fsSL https://raw.githubusercontent.com/viniciussgoncalves/Ops-Script_Install_Docker/main/docker_setup.sh | bash
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

### identify_distribution

Identifies the current Linux distribution.

### get_distro_color

Returns the appropriate color code based on the Linux distribution.

### spinner

Displays a spinner to indicate progress during long-running operations.

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

################################################################################
# Script Name   : Docker Setup                                                 #
# Description   : Script to install Docker                                     #
# Version       : 2.0                                                          #
# Author        : Vinicius Gonçalves                                           #
################################################################################

Installing Docker on Ubuntu distribution

Starting: Package update
 [|]
Package update completed successfully.
Starting: Dependency installation
 [-]
Dependency installation completed successfully.
Starting: Add Docker GPG key
 [/]
Docker GPG key added successfully.
Starting: Add Docker repository
 [\]
Docker repository added successfully.
Starting: Update package index
 [|]
Package index updated successfully.
Starting: Docker packages installation
 [-]
Docker packages installed successfully.
Starting: Enable and start Docker service
 [/]
Docker service enabled and started successfully.
Starting: Add user to Docker group
 [\]
User added to Docker group successfully.
Starting: Finalizing installation
Installation process completed.

WARNING: Please log out and log back in as user for the changes to take effect.
```
