# Use the official Terraform image as the base image
FROM hashicorp/terraform:latest

# Set the working directory inside the container
WORKDIR /app

# Copy your Terraform configuration files into the container
COPY . /app

# Optionally, you can run any initialization or setup commands here
RUN terraform init

# The default command to run when the container starts
CMD ["terraform", "apply"]
