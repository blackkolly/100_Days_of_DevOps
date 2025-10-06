One of the Nautilus DevOps team members was working to configure services on a kkloud container that is running on App Server 2 in Stratos Datacenter.
Due to some personal work he is on PTO for the rest of the week, but we need to finish his pending work ASAP. 
Please complete the remaining work as per details given below:

a. Install apache2 in kkloud container using apt that is running on App Server 2 in Stratos Datacenter.
b. Configure Apache to listen on port 6100 instead of default http port. Do not bind it to listen on specific IP or hostname only,
i.e it should listen on localhost, 127.0.0.1, container ip, etc.
c. Make sure Apache service is up and running inside the container. Keep the container in running state at the end.


Step 1 – SSH into App Server 2

From the jump host:

ssh steve@stapp02   # password: Am3ric@


Switch to root:
sudo -i

Step 2 – Confirm container exists and is running

docker ps


Look for a container named kkloud.
If it’s stopped, start it:


docker start kkloud


Step 3 – Enter the container

docker exec -it kkloud bash

Step 4 – Install Apache (inside the container)

Update package lists and install Apache:

apt update
apt install -y apache2

 Step 5 – Change Apache listen port to 6100

Edit the ports configuration file:


sed -i 's/Listen 80/Listen 6100/' /etc/apache2/ports.conf


Also update the default virtual host file:

sed -i 's/<VirtualHost \*:80>/<VirtualHost *:6100>/' /etc/apache2/sites-available/000-default.conf

Step 6 – Restart Apache

If it still doesn’t start, check logs
you can fix it with:
echo "ServerName localhost" >> /etc/apache2/apache2.conf
service apache2 restart

Check status:
service apache2 status

You should see it active (running).

Step 7 – Confirm Apache listens on port 6100

ss -tuln | grep 6100
If it says “command not found”, you can install it:
apt update
apt install -y net-tools
Thus rerun the command

Expected output:

LISTEN 0 128 0.0.0.0:6100 ...

Verify from host:
docker ps --filter "name=kkloud"

