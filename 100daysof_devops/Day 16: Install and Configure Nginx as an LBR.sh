Day by day traffic is increasing on one of the websites managed by the Nautilus production support team. Therefore, the team has observed a degradation in website performance. Following discussions about this issue, the team has decided to deploy this application on a high availability stack i.e on Nautilus infra in Stratos DC. They started the migration last month and it is almost done, as only the LBR server configuration is pending. Configure LBR server as per the information given below:



a. Install nginx on LBR (load balancer) server.


b. Configure load-balancing with the an http context making use of all App Servers. Ensure that you update only the main Nginx configuration file located at /etc/nginx/nginx.conf.


c. Make sure you do not update the apache port that is already defined in the apache configuration on all app servers, also make sure apache service is up and running on all app servers.


d. Once done, you can access the website using StaticApp button on the top bar.



 1. Install Nginx

sudo yum install -y nginx   # CentOS/RHEL

Enable & start:


sudo systemctl enable nginx
sudo systemctl start nginx

2. Configure Load Balancing in `/etc/nginx/nginx.conf`

Edit only the main config file and add the upstream + server block.

Open:
sudo vi /etc/nginx/nginx.conf

Inside the `http { ... }` block, add:


http {
    upstream backend {
        server 172.16.238.10:8083;   # stapp01
        server 172.16.238.11:8083;   # stapp02
        server 172.16.238.12:8083;   # stapp03
    }

    server {
        listen 80;

        location / {
            proxy_pass http://backend;
        }
    }

Ensure that the Apache port is currently defined on the app servers (some are running on in your environment). 
 3. Validate and Restart Nginx

sudo nginx -t
sudo systemctl restart nginx

4. Verify

From the jump host:
curl -I http://stlb01
