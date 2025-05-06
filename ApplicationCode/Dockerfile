# Use the official Tomcat 11.0.1 image as the base
FROM tomcat:11.0.1-jre21-temurin-noble


# Set the working directory inside the container
WORKDIR /usr/local/tomcat

# Copy your HTML application into the webapps directory
# Replace 'your-app' with the name of your application folder
COPY index.html script.js styles.css /usr/local/tomcat/webapps/ApplicationCode/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
