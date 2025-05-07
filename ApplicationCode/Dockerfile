FROM tomcat:latest

# Set the working directory inside the container
WORKDIR /usr/local/tomcat

RUN apt-get update && apt-get install -y zip 

COPY index.html script.js styles.css  WEB-INF/ /usr/local/tomcat/

RUN mkdir WEB-INF && cp web.xml WEB-INF/web.xml 
RUN zip -r WebApp.zip index.html script.js styles.css WEB-INF/ 
RUN cp WebApp.zip /usr/local/tomcat/webapps/WebApp.war 
RUN rm -r WebApp.zip index.html script.js styles.css WEB-INF/ 
# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
