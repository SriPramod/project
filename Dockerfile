FROM tomcat:7
COPY  project/target/WebAppCal-0.1.4.war /usr/local/tomcat/webapps/
RUN mv webapps.dist/* webapps
EXPOSE 8080
