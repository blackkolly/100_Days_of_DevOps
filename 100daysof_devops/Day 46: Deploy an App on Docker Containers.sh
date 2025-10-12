The Nautilus DevOps team is working to create new images per requirements shared by the development team. One of the team members is working to create
a Dockerfile on App Server 2 in Stratos DC. While working on it she ran into issues in which the docker build is failing and displaying errors.
Look into the issue and fix it to build an image as per details mentioned below:

a. The Dockerfile is placed on App Server 2 under /opt/docker directory.
b. Fix the issues with this file and make sure it is able to build the image.
c. Do not change base image, any other valid configuration within Dockerfile, or any of the data been used — for example, index.html.
Note: Please note that once you click on FINISH button all the existing containers will be destroyed and new image will be built from your Dockerfile.



Step 1 — Inspect the Dockerfile


cd /opt/docker
cat Dockerfile

sudo vi /opt/docker/Dockerfile

Step 2 — Correct common Dockerfile issues

IMAGE httpd:2.4.43

ADD sed -i "s/Listen 80/Listen 8080/g" /usr/local/apache2/conf/httpd.conf

ADD sed -i '/LoadModule\ ssl_module modules\/mod_ssl.so/s/^#//g' conf/httpd.conf

ADD sed -i '/LoadModule\ socache_shmcb_module modules\/mod_socache_shmcb.so/s/^#//g' conf/httpd.conf

ADD sed -i '/Include\ conf\/extra\/httpd-ssl.conf/s/^#//g' conf/httpd.conf

COPY certs/server.crt /usr/local/apache2/conf/server.crt

COPY certs/server.key /usr/local/apache2/conf/server.key

COPY html/index.html /usr/local/apache2/htdocs/

Corrected
FROM httpd:2.4.43

# Change Apache listening port from 80 → 8080
RUN sed -i "s/Listen 80/Listen 8080/g" /usr/local/apache2/conf/httpd.conf

# Enable SSL and socache modules + include SSL config
RUN sed -i '/LoadModule ssl_module modules\/mod_ssl.so/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/LoadModule socache_shmcb_module modules\/mod_socache_shmcb.so/s/^#//g' /usr/local/apache2/conf/httpd.conf && \
    sed -i '/Include conf\/extra\/httpd-ssl.conf/s/^#//g' /usr/local/apache2/conf/httpd.conf

# Copy SSL certificates
COPY certs/server.crt /usr/local/apache2/conf/server.crt
COPY certs/server.key /usr/local/apache2/conf/server.key

# Copy website content
COPY html/index.html /usr/local/apache2/htdocs/


Step 3 — Test building the image

Once fixed, build the image again:

sudo docker build -t fixed-httpd-image:latest /opt/docker

Step 4 — Verify

sudo docker images


and optionally test by running:

sudo docker run -d -p 8080:80 fixed-httpd-image:latest
curl http://localhost:8080

