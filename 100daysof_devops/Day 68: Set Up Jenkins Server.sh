The DevOps team at xFusionCorp Industries is initiating the setup of CI/CD pipelines and has decided to utilize Jenkins as their server. 
Execute the task according to the provided requirements:

1. Install Jenkins on the jenkins server using the yum utility only, and start its service.
If you face a timeout issue while starting the Jenkins service, refer to this.
2. Jenkin's admin user name should be theadmin, password should be Adm!n321, full name should be Mariyam and email should be mariyam@jenkins.stratos.xfusioncorp.com.

Note:
1. To access the jenkins server, connect from the jump host using the root user with the password S3curePass.
2. After Jenkins server installation, click the Jenkins button on the top bar to access the Jenkins UI and follow on-screen instructions to create an admin user.




Connect to the Jenkins server

From your jump host:

ssh root@jenkins.stratos.xfusioncorp.com
# Password: S3curePass


Ensure Java 17 is installed**

Jenkins now requires Java 17 or 21, so first check if Java 17 is available:


java -version


If it shows Java 11 or older, install OpenJDK 17:

yum install -y java-17-openjdk java-17-openjdk-devel

Check the path:

readlink -f $(which java)
/usr/lib/jvm/java-17-openjdk-17.0.*/bin/java


Set JAVA_HOME for Jenkins

Edit `/etc/sysconfig/jenkins`:

vi /etc/sysconfig/jenkins


Update or add:

JAVA_HOME=/usr/lib/jvm/java-17-openjdk-17.0.x.x


Replace `17.0.x.x` with the exact path from the previous step.


Install Jenkins via yum

Add Jenkins repository:

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key


Install Jenkins:

yum install -y jenkins

Start and enable Jenkins service**

Reload systemd and start Jenkins:


systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
systemctl status jenkins -l


If Jenkins fails to start, make sure `JAVA_HOME` points to Java 17, then:

systemctl daemon-reload
systemctl reset-failed
systemctl start jenkins

 Access Jenkins UI

Open the Jenkins UI by clicking the Jenkins button on the top bar.
Follow on-screen instructions to unlock Jenkins (you may need the initial password from `/var/lib/jenkins/secrets/initialAdminPassword`):


cat /var/lib/jenkins/secrets/initialAdminPassword


### **7️⃣ Create the Admin User**

Username: `theadmin`
*Password: `Adm!n321`
Full Name: `Mariyam`
Email:`mariyam@jenkins.stratos.xfusioncorp.com`

-
