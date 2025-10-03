The Nautilus DevOps team is conducting application deployment tests on selected application servers. They require a nginx container deployment 
on Application Server 3. Complete the task with the following instructions:
On Application Server 3 create a container named nginx_3 using the nginx image with the alpine tag. Ensure container is in a running state.


 Step 1: SSH into App Server 3

From jump host:
ssh banner@stapp03   # password: BigGr33n
Switch to root:
sudo -i

Step 2: Pull the nginx alpine image

docker pull nginx:alpine

Step 3: Run the container

Create and start the container named `nginx_3`:
docker run -d --name nginx_3 nginx:alpine


Step 4: Verify container is running

docker ps

CONTAINER ID   IMAGE          COMMAND                  STATUS         PORTS   NAMES
abc123def456   nginx:alpine   "/docker-entrypoint.…"   Up X minutes           nginx_3
