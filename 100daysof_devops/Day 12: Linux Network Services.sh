Our monitoring tool has reported an issue in Stratos Datacenter. One of our app servers has an issue, as its Apache service is not reachable on port 3002 (which is the Apache port). The service itself could be down, the firewall could be at fault, or something else could be causing the issue.



Use tools like telnet, netstat, etc. to find and fix the issue. Also make sure Apache is reachable from the jump host without compromising any security settings.

Once fixed, you can test the same using command curl http://stapp01:3002 command from jump host.

Note: Please do not try to alter the existing index.html code, as it will lead to task failure.
step 1: SSH into the App Server
ssh tony@stapp01

Step 2: Check if Apache is running
sudo systemctl status httpd
If inactive/failing, start and enable it:

sudo systemctl start httpd
sudo systemctl enable httpd

Step 3: Check what process is listening on 3002
sudo ss -ltnp | grep 3002
# or
sudo netstat -tulnp | grep 3002
Ensure Apache (httpd) is actually bound to port 3002.
If another service is using 3002, stop that service.
Check iptables directly (CentOS/RHEL systems often fall back to iptables if firewalld is absent).
step 4:
Let’s check if iptables is active:

sudo iptables -L -n -v
Look for any rules blocking port 3002. If there’s a DROP or REJECT on that port, we’ll need to add a rule to allow it:
sudo iptables -I INPUT -p tcp --dport 3002 -j ACCEPT

Step 5: Test locally on the App Server
From jump host (thor):

curl http://stapp01:3002
# or
telnet stapp01
