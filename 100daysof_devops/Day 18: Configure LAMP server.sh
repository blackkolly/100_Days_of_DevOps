xFusionCorp Industries is planning to host a WordPress website on their infra in Stratos Datacenter. They have already done infrastructure configuration—for example, on the storage server they already have a shared directory /vaw/www/html that is mounted on each app host under /var/www/html directory. Please perform the following steps to accomplish the task:



a. Install httpd, php and its dependencies on all app hosts.


b. Apache should serve on port 8086 within the apps.


c. Install/Configure MariaDB server on DB Server.


d. Create a database named kodekloud_db4 and create a database user named kodekloud_rin identified as password BruCStnMT5. Further make sure this newly created user is able to perform all operation on the database you created.


e. Finally you should be able to access the website on LBR link, by clicking on the App button on the top bar. You should see a message like App is able to connect to the database using user kodekloud_rinPerfect 👌 — let’s walk through the **WordPress hosting setup on xFusionCorp infra** step by step. I’ll structure it so you can run the commands host-by-host.


Step A: Install Apache (httpd), PHP, and dependencies on **all App hosts** (`stapp01`, `stapp02`, `stapp03`)

SSH into each app server via the jump host:

ssh tony@stapp01   # (password: Ir0nM@n)
# Similarly: steve@stapp02, banner@stapp03

On each App server, run:
# Install Apache, PHP, and extensions
sudo yum install -y httpd php php-mysqlnd php-fpm php-gd

Change Apache port to 8086
sudo sed -i 's/^Listen 80/Listen 8086/' /etc/httpd/conf/httpd.conf

# Allow port 8086 in SELinux/firewalld (if enabled)
sudo firewall-cmd --permanent --add-port=8086/tcp
sudo firewall-cmd --reload

# Start & enable Apache
sudo systemctl enable httpd
sudo systemctl start httpd

Step B: Configure MariaDB on DB server (`stdb01`)

SSH:
ssh peter@stdb01   # (password: Sp!dy)

Install MariaDB:
sudo yum install -y mariadb-server
sudo systemctl enable mariadb
sudo systemctl start mariadb


Login and configure database:

mysql -u root

Inside MySQL:
CREATE DATABASE kodekloud_db4;
CREATE USER 'kodekloud_sam'@'%' IDENTIFIED BY 'BruCStnMT5';
GRANT ALL PRIVILEGES ON kodekloud_db4.* TO 'kodekloud_sam'@'%';
FLUSH PRIVILEGES;
EXIT;

Allow MariaDB to listen on all interfaces:

sudo sed -i 's/^bind-address/#bind-address/' /etc/my.cnf
sudo systemctl restart mariadb

Also open DB port (3306):

sudo firewall-cmd --permanent --add-port=3306/tcp
sudo firewall-cmd --reload


On any app server (`stapp01`, same for all since `/var/www/html` is shared):

 Step C: Create a PHP test page on each App server

On each app server (`stapp01`, `stapp02`, `stapp03`):

cd /var/www/html

# Create a PHP file
sudo tee dbtest.php > /dev/null <<'EOF'
<?php
$servername = "stdb01.stratos.xfusioncorp.com";
$username = "kodekloud_sam";
$password = "BruCStnMT5";
$dbname = "kodekloud_db4";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
echo "App is able to connect to the database using user kodekloud_sam";
$conn->close();

2. Create config file:

```bash
sudo cp wp-config-sample.php wp-config.php
sudo sed -i 's/database_name_here/kodekloud_db4/' wp-config.php
sudo sed -i 's/username_here/kodekloud_sam/' wp-config.php
sudo sed -i 's/password_here/BruCStnMT5/' wp-config.php
sudo sed -i "s/localhost/stdb01.stratos.xfusioncorp.com/" wp-config.php
```

3. Adjust permissions:
sudo chown -R apache:apache /var/www/html

Step D: Test via Load Balancer (`stlb01`)

On the load balancer server:

ssh loki@stlb01   # (password: Mischi3f)

Ensure HAProxy (or httpd/nginx if used for LBR) forwards traffic to port 8086 on app servers. Example for HAProxy (`/etc/haproxy/haproxy.cfg`):
frontend http_front
    bind *:80
    default_backend app_back

backend app_back
    balance roundrobin
    server stapp01 172.16.238.10:8086 check
    server stapp02 172.16.238.11:8086 check
    server stapp03 172.16.238.12:8086 check

Restart load balancer:
sudo systemctl restart haprox
Ensure Apache is running on port 8086

sudo systemctl start httpd
sudo systemctl enable httpd

Access via Load Balancer

If the load balancer is configured to forward traffic to app servers on port 8086, open in a browser:

http://<LBR_IP_or_Hostname>:80/dbtest.php

You should see:

App is able to connect to the database using user kodekloud_sam



