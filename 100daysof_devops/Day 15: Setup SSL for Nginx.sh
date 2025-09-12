The system admins team of xFusionCorp Industries needs to deploy a new application on App Server 2 in Stratos Datacenter. They have some pre-requites to get ready that server for application deployment. Prepare the server as per requirements shared below:


1. Install and configure nginx on App Server 2.


2. On App Server 2 there is a self signed SSL certificate and key present at location /tmp/nautilus.crt and /tmp/nautilus.key. Move them to some appropriate location and deploy the same in Nginx.


3. Create an index.html file with content Welcome! under Nginx document root.


4. For final testing try to access the App Server 2 link (either hostname or IP) from jump host using curl command. For example curl -Ik https://<app-server-ip>/.Here’s a step-by-step guide to prepare **App Server 2** for the new application deployment using Nginx with SSL:


Step 1: SSH into App Server 2


ssh steve@stapp02
# Password: Am3ric@

Step 2: Install Nginx

sudo yum install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

Check status:

sudo systemctl status nginx --no-pager

Step 3: Move SSL certificate and key to proper location

A common location for SSL certs:


sudo mkdir -p /etc/nginx/ssl
sudo mv /tmp/nautilus.crt /etc/nginx/ssl/
sudo mv /tmp/nautilus.key /etc/nginx/ssl/
sudo chmod 600 /etc/nginx/ssl/nautilus.key
sudo chmod 644 /etc/nginx/ssl/nautilus.crt

Step 4: Configure Nginx for SSL

Edit or create a server block in `/etc/nginx/conf.d/nautilus.conf`:


sudo vi /etc/nginx/conf.d/nautilus.conf


Add the following:

nginx
server {
    listen 443 ssl;
    server_name stapp02.stratos.xfusioncorp.com;

    ssl_certificate     /etc/nginx/ssl/nautilus.crt;
    ssl_certificate_key /etc/nginx/ssl/nautilus.key;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}

Optional: Redirect HTTP (port 80) to HTTPS:

nginx
server {
    listen 80;
    server_name stapp02.stratos.xfusioncorp.com;
    return 301 https://$host$request_uri;
    }

Step 5: Create the index.html file

echo "Welcome!" | sudo tee /usr/share/nginx/html/index.html
Step 6: Test Nginx configuration
sudo nginx -t
If syntax OK, restart Nginx:

sudo systemctl restart nginx

Step 7: Verify from jump host

From jump host (`thor`):
curl -Ik https://stapp02.stratos.xfusioncorp.com/
 or using IP
curl -Ik https://172.16.238.11/
You should get HTTP `200 OK` and SSL certificate info

