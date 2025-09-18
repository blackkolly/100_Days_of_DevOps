xFusionCorp Industries is planning to host two static websites on their infra in Stratos Datacenter. The development of these websites is still in-progress, but we want to get the servers ready. Please perform the following steps to accomplish the task:



a. Install httpd package and dependencies on app server 1.


b. Apache should serve on port 3001.


c. There are two website's backups /home/thor/beta and /home/thor/demo on jump_host. Set them up on Apache in a way that beta should work on the link http://localhost:3001/beta/ and demo should work on link http://localhost:3001/demo/ on the mentioned app server.


d. Once configured you should be able to access the website using curl command on the respective app server, i.e curl http://localhost:3001/beta/ and curl http://localhost:3001/demo/

Got it 👍 This task is about preparing **App Server 1 (stapp01)** to serve **two static websites** (`beta` and `demo`) on Apache running on port **3001**. Here’s exactly how you can do it:



Step A: Install Apache on stapp01

SSH to `stapp01` through the jump host:

ssh tony@stapp01    # password: Ir0nM@n

On stapp01:


sudo yum install -y httpd

Step B: Configure Apache to listen on port 3001

Edit the main config:


sudo sed -i 's/^Listen 80/Listen 3001/' /etc/httpd/conf/httpd.conf


Step C: Copy websites (`beta` and `demo`) from jump\_host to stapp01

1. Exit back to jump\_host (`thor@jump_host`).
2. Copy directories over to **stapp01**:


scp -r /home/thor/beta tony@stapp01:/tmp/
scp -r /home/thor/demo tony@stapp01:/tmp/

3. SSH back into stapp01:


ssh tony@stapp01

4. Move them into Apache’s document root:

sudo mkdir -p /var/www/html/beta
sudo mkdir -p /var/www/html/demo

sudo cp -r /tmp/beta/* /var/www/html/beta/
sudo cp -r /tmp/demo/* /var/www/html/demo/


Step D: Create Apache configuration for subdirectories

Since you’re serving them under `/beta/` and `/demo/`, the default `DocumentRoot` works fine. Just make sure Apache allows indexes.

Add these directives at the bottom of `/etc/httpd/conf/httpd.conf`:
Note inside the confi 
Includeoptional(Remove the rest) 
Alias /beta /var/www/html/beta
<Directory /var/www/html/beta>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

Alias /demo /var/www/html/demo
<Directory /var/www/html/demo>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>

Step E: Restart Apache
sudo systemctl enable httpd
sudo systemctl restart httpd

Step F: Test on stapp01

Run:
curl http://localhost:3001/beta/
curl http://localhost:3001/demo/

