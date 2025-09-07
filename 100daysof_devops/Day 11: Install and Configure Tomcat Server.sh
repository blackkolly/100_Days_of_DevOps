The Nautilus application development team recently finished the beta version of one of their Java-based applications, which they are planning to deploy on one of the app servers in Stratos DC. After an internal team meeting, they have decided to use the tomcat application server. Based on the requirements mentioned below complete the task:

a. Install tomcat server on App Server 3.
b. Configure it to run on port 8082.
c. There is a ROOT.war file on Jump host at location /tmp.
Deploy it on this tomcat server and make sure the webpage works directly on base URL i.e curl http://stapp03:8082Steps

1. Connect to App Server 3

From jump host as thor, SSH into App Server 3 (banner user):

ssh banner@stapp03

2. Install Tomcat

Depending on the OS (likely CentOS/RHEL based in Stratos DC):

# Become root
sudo -i

# Install tomcat
sudo yum install -y tomcat tomcat-webapps tomcat-admin-webapps tomcat-docs-webapp

Enable and start:

systemctl enable tomcat
systemctl start tomcat

3. Change Tomcat Port to 8082

Edit /etc/tomcat/server.xml:

sudo vi /etc/tomcat/server.xml


Find this line:

<Connector port="8080" protocol="HTTP/1.1" ... />


Change 8080 → 8082.

Restart Tomcat:

sudo systemctl restart tomcat

4. Copy the WAR file from Jump Host

On Jump host (as thor):

scp /tmp/ROOT.war banner@stapp03:/tmp/


On App Server 3:

sudo mv /tmp/ROOT.war /var/lib/tomcat/webapps/


Tomcat will auto-deploy it (unzips into /var/lib/tomcat/webapps/ROOT).

5. Verify Deployment

Check logs:

sudo tail -f /var/log/tomcat/catalina.out


Test with curl from App Server 3:

curl http://localhost:8082


Or from jump host:

curl http://stapp03:8082


