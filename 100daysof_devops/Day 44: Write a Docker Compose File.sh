The Nautilus application development team shared static website content that needs to be hosted on the httpd web server using a containerised platform. 
The team has shared details with the DevOps team, and we need to set up an environment according to those guidelines. Below are the details:

a. On App Server 2 in Stratos DC create a container named httpd using a docker compose file /opt/docker/docker-compose.yml (please use the exact name for file).
b. Use httpd (preferably latest tag) image for container and make sure container is named as httpd; you can use any name for service.
c. Map 80 number port of container with port 6400 of docker host.
d. Map container's /usr/local/apache2/htdocs volume with /opt/itadmin volume of docker host which is already there. 
(please do not modify any data within these locations).


Step 1 — Confirm prerequisites

Make sure Docker and Docker Compose are installed and running:

sudo systemctl start docker
sudo systemctl enable docker
docker --version
docker compose version


Step 2 — Create the Docker Compose directory

sudo mkdir -p /opt/docker
cd /opt/docker


Step 3 — Create the `docker-compose.yml` file


sudo vi /opt/docker/docker-compose.yml


version: '3.8'

services:
  web:
    image: httpd:latest
    container_name: httpd
    ports:
      - "6400:80"
    volumes:
      - /opt/itadmin:/usr/local/apache2/htdocs
    
Step 4 — Deploy the container using Docker Compose

sudo docker compose up -d```

You should see:
[+] Running 1/1
 ✔ Container httpd  Started
Step 5 — Verify the container

sudo docker ps

Expected output:

CONTAINER ID   IMAGE         COMMAND              CREATED          STATUS          PORTS                  NAMES
abcd1234efgh   httpd:latest  "httpd-foreground"   10 seconds ago   Up 10 seconds   0.0.0.0:6400->80/tcp   httpd

Step 6 — Test the setup
curl http://localhost:6400
