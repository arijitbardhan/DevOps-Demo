# Use the official Tomcat 11.0.1 image as the base
FROM tomcat:latest

# RUN apt update && apt install default-jdk -y \
#    mkdir -p /opt/tomcat && groupadd tomcat && useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat \
#    mkdir tmp && cd /tmp \
#    curl -O https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.6/bin/apache-tomcat-11.0.6.tar.gz \
#    tar xzvf apache-tomcat-11*tar.gz -C /opt/tomcat --strip-components=1 \
#    chown -RH tomcat: /opt/tomcat && sh -c 'chmod +x /opt/tomcat/bin/*.sh' && update-java-alternatives -l

# Set the working directory inside the container
WORKDIR /usr/local/tomcat

# Copy your HTML application into the webapps directory
# Replace 'your-app' with the name of your application folder
COPY index.html script.js styles.css  WEB-INF/ /

RUN apt-get update && apt-get install -y zip && zip -r WebApp.zip *

RUN cp WebApp.zip webapps/WebApp.war
# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
