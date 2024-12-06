rm WebApp.*
zip -r WebApp.zip *
cp WebApp.zip WebApp.war
cp WebApp.war /opt/tomcat/webapps/WebApp.war
sudo service tomcat restart
