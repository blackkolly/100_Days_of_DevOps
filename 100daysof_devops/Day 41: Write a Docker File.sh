As per recent requirements shared by the Nautilus application development team, they need custom images created for one of their projects. 
Several of the initial testing requirements are already been shared with DevOps team. 
Therefore, create a docker file /opt/docker/Dockerfile (please keep D capital of Dockerfile) on App server 3 in Stratos DC and configure
to build an image with the following requirements:

a. Use ubuntu:24.04 as the base image.
b. Install apache2 and configure it to work on 8089 port. (do not update any other Apache configuration settings like document root etc).

Step 1 — Create the required directory and Dockerfile**

sudo mkdir -p /opt/docker
sudo vi /opt/docker/Dockerfile

Step 2 — Add the following content to `/opt/docker/Dockerfile

FROM ubuntu:24.04

RUN apt-get update && apt-get install -y apache2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/80/8089/g' /etc/apache2/ports.conf && \
    sed -i 's/:80/:8089/g' /etc/apache2/sites-available/000-default.conf

EXPOSE 8089
CMD ["apachectl", "-D", "FOREGROUND"]


Step 3 — Build the Docker image

sudo docker build -t custom-ubuntu-apache:latest .

Step 4 — Run a container to verify Apache runs on port 8089:
sudo docker run -d -p 8089:8089 --name apache_test custom-ubuntu-apache

Then confirm it works:

curl http://localhost:8089


