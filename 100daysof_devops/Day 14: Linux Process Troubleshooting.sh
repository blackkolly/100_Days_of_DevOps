The production support team of xFusionCorp Industries has deployed some of the latest monitoring tools to monitor every service, application, etc., running on the systems. One of the monitoring systems reported about Apache service unavailability on one of the app servers in Stratos DC.
Identify the faulty app host and fix the issue. Make sure the Apache service is up and running on all app hosts. They might not have hosted any code yet on these servers, so you don’t need to worry if Apache isn’t serving any pages. Just make sure the service is up and running. Also, make sure Apache is running on port 3003 on all app servers.

Alright ✅ — let’s tackle this Apache availability issue across all 3 app servers** (`stapp01`, `stapp02`, `stapp03`).

The requirement: Apache must listen on port 3003 (not the default 80/8080).


Step 1: SSH into each app server

From jump host:


ssh tony@stapp01   # pass: Ir0nM@n
ssh steve@stapp02  # pass: Am3ric@
ssh banner@stapp03 # pass: BigGr33n

Step 2: Check Apache status

On each app server:

sudo systemctl status httpd

If it’s inactive/failed, we’ll fix config + restart.

Step 3: Configure Apache to listen on 3003

Edit `/etc/httpd/conf/httpd.conf`:

sudo vi /etc/httpd/conf/httpd.conf

Find the Listen directive and update:

Listen 3003

Also update `ServerName` (optional but prevents warnings):

ServerName 0.0.0.0:3003

Step 4: Check port binding

Ensure no other service is occupying port 3003:
sudo netstat -tulnp | grep 3003

If `sendmail` or another process is binding it, stop/disable it:
sudo systemctl stop sendmail
sudo systemctl disable sendmail

Step 5: Restart Apache
sudo systemctl daemon-reexec
sudo systemctl restart httpd
sudo systemctl enable httpd

Step 6: Verify
Listening on correct port:
sudo netstat -tulnp | grep 3003
or 
sudo ss -ltnp | grep 3003
