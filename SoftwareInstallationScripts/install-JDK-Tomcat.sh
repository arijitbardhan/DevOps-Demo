#!/bin/bash

# Function to print decorative header
print_header() {
    echo "============================================="
    echo "$1"
    echo "============================================="
}

# Function to install Java
install_java() {
    print_header "Checking and Installing Java"
    if [ -n `which java` ]; then
        echo "Java is already installed."
    else
        echo "Java is not installed. Installing Java..."
        # Install Java (OpenJDK)
        sudo apt-get update
        sudo apt-get install -y default-jdk
        echo "Java installation completed."
    fi
}

# Function to install Tomcat
install_tomcat() {
    print_header "Installing Tomcat"
    # Create a directory for Tomcat installation
    sudo mkdir -p /opt/tomcat

    # Fetch the latest version of Tomcat from the Apache website
    latest_version=$(curl -s https://tomcat.apache.org/download-90.cgi | grep -o 'apache-tomcat-[0-9]*.[0-9]*.[0-9]*.tar.gz' | head -1)
    version_number=$(echo $latest | grep -oP 'apache-tomcat-\K[0-9]+\.[0-9]+\.[0-9]+')
    # Download the latest version
    wget https://downloads.apache.org/tomcat/tomcat-9/v$version_number/bin/$latest_version -O /tmp/tomcat.tar.gz

    # Extract the archive
    sudo tar -xzf /tmp/tomcat.tar.gz -C /opt/tomcat --strip-components=1

    # Set permissions
    sudo chown -R $(whoami): /opt/tomcat

    # Cleanup
    rm /tmp/tomcat.tar.gz

    echo "Tomcat installation completed successfully."
}

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please run again with sudo." >&2
    exit 1
else
    # Install Java
    install_java

    # Install Tomcat
    install_tomcat
fi

print_header "Tomcat Installation Script Completed"
