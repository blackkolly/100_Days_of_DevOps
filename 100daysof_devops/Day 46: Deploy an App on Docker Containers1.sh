The Nautilus Application development team recently finished development of one of the apps that they want to deploy on a containerized platform. 
The Nautilus Application development and DevOps teams met to discuss some of the basic pre-requisites and requirements to complete the deployment. 
The team wants to test the deployment on one of the app servers before going live and set up a complete containerized stack using a docker compose fie.
Below are the details of the task:

On App Server 3 in Stratos Datacenter create a docker compose file /opt/itadmin/docker-compose.yml (should be named exactly)
The compose should deploy two services (web and DB), and each service should deploy a container as per details below:
For web service:
a. Container name must be php_host.
b. Use image php with any apache tag. Check here for more details.
c. Map php_host container's port 80 with host port 6400
d. Map php_host container's /var/www/html volume with host volume /var/www/html.


For DB service:
a. Container name must be mysql_host.
b. Use image mariadb with any tag (preferably latest). Check here for more details.
c. Map mysql_host container's port 3306 with host port 3306
d. Map mysql_host container's /var/lib/mysql volume with host volume /var/lib/mysql.
e. Set MYSQL_DATABASE=database_host and use any custom user ( except root ) with some complex password for DB connections.

After running docker-compose up you can access the app with curl command curl <server-ip or hostname>:6400/
For more details check here.
Note: Once you click on FINISH button, all currently running/stopped containers will be destroyed and stack will be deployed again using your compose file.



Step-by-Step Solution

1. Create the compose directory inside stapp03( ssh banner@stapp03)

sudo mkdir -p /opt/itadmin
cd /opt/itadmin

2. Create the Docker Compose file

sudo vi /opt/itadmin/docker-compose.yml


version: "3.8"

services:
  web:
    image: php:8.2-apache
    container_name: php_host
    ports:
      - "6400:80"
    volumes:
      - /var/www/html:/var/www/html
    depends_on:
      - db

  db:
    image: mariadb:latest
    container_name: mysql_host
    ports:
      - "3306:3306"
    environment:
      MYSQL_DATABASE: database_host
      MYSQL_USER: appuser
      MYSQL_PASSWORD: Str@t0sP@ss
      MYSQL_ROOT_PASSWORD: R00tP@ss
    volumes:
      - /var/lib/mysql:/var/lib/mysql

3. Bring up the stack

sudo docker compose up -d


Expected output:
[+] Running 2/2
 ✔ Container mysql_host  Started
 ✔ Container php_host    Started
4. Verify containers

sudo docker ps

Output example:
CONTAINER ID   IMAGE             PORTS                     NAMES
a1b2c3d4e5f6   php:8.2-apache    0.0.0.0:6400->80/tcp      php_host
b2c3d4e5f6g7   mariadb:latest    0.0.0.0:3306->3306/tcp    mysql_host

5. Test the setup

From App Server 3 itself:
curl http://localhost:6400/
