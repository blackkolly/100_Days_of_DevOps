The Nautilus DevOps team possesses confidential data on App Server 2 in the Stratos Datacenter. A container named ubuntu_latest is running on the same server.
Cop an encrypted file /tmp/nautilus.txt.gpg from the docker host to the ubuntu_latest container located at /tmp/. Ensure the file is
not modified during this operation.

🔹 Step 1: SSH into App Server 2

From the jump host:

ssh steve@stapp02   # password: Am3ric@


Switch to root if needed:

sudo -i

🔹 Step 2: Verify the container is running
docker ps


You should see a container named ubuntu_latest.

🔹 Step 3: Copy the encrypted file into container
docker cp /tmp/nautilus.txt.gpg ubuntu_latest:/tmp/

🔹 Step 4: Verify inside the container

Open a shell inside ubuntu_latest:

docker exec -it ubuntu_latest ls -l /tmp/


You should see:

-rw-r--r--  1 root root   <size>  <date> nautilus.txt.gpg
