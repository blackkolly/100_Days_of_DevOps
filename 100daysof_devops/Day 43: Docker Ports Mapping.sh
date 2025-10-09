The Nautilus DevOps team is planning to host an application on a nginx-based container. There are number of tickets already been created for similar tasks.
One of the tickets has been assigned to set up a nginx container on Application Server 2 in Stratos Datacenter. Please perform the task as per details
mentioned below:

a. Pull nginx:stable docker image on Application Server 2.
b. Create a container named apps using the image you pulled.
c. Map host port 8082 to container port 80. Please keep the container in running state.


Step 1 — Ensure Docker is running

sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker

Step 2 — Pull the nginx:stable image

sudo docker pull nginx:stable

You should see output confirming the image has been downloaded.

Step 3 — Run a container named `apps`

Create and start the container with the required port mapping:

sudo docker run -d --name apps -p 8082:80 nginx:stable

Explanation

-d → Run in detached mode (background)
--name apps → Names the container `apps`
-p 8082:80 → Maps host port 8082→ container port 80
nginx:stable → The image to use

Step 4 — Verify the container is running

sudo docker ps

Expected output:

CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
abcd1234efgh   nginx:stable   "/docker-entrypoint.…"   5 seconds ago   Up 5 seconds   0.0.0.0:8082->80/tcp   apps

Step 5 — Test nginx is working

Run this from the App Server 2 host:

curl http://localhost:8082

You should see the default Nginx welcome HTML page (something like:
`<!DOCTYPE html><html><head><title>Welcome to nginx!</title>...`).



