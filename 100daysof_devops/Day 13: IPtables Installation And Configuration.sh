We have one of our websites up and running on our Nautilus infrastructure in Stratos DC. Our security team has raised a concern that right now Apache’s port i.e 5000 is open for all since there is no firewall installed on these hosts. So we have decided to add some security layer for these hosts and after discussions and recommendations we have come up with the following requirements:

1. Install iptables and all its dependencies on each app host.
2. Block incoming port 5000 on all apps for everyone except for LBR host.
3. Make sure the rules remain, even after system reboot


Got it ✅ — the security team wants **iptables-based firewalling** on all app servers (`stapp01`, `stapp02`, `stapp03`) so that:

* Apache (`5000/tcp`) is **only accessible from the Load Balancer** (`stlb01`, IP: `172.16.238.14`).
* All other hosts must be blocked.
* Rules must persist after reboot.

Here’s how you can set it up on each app server:


Step 1: Install iptables (and persistence)

Login to each app server (`stapp01`, `stapp02`, `stapp03`) and run:


sudo yum install -y iptables iptables-services

Enable iptables service to start on boot:
sudo systemctl enable iptables
sudo systemctl start iptables
Step 2: Configure iptables rules

Flush existing rules to start clean:

sudo iptables -F
Now add rules:

# Allow existing/established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow localhost
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow SSH so you don’t lock yourself out
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow Apache (5000) only from LBR host
sudo iptables -A INPUT -p tcp -s 172.16.238.14 --dport 5000 -j ACCEPT

# Drop all other incoming connections
sudo iptables -A INPUT -j DROP
Step 3: Save rules for persistence

On each app server:
sudo service iptables save

This writes rules to `/etc/sysconfig/iptables`.
Step 4: Verify

jump host
# From jump host (should fail)
curl http://stapp01:5000

# From LBR host (should succeed)
ssh loki@stlb01
curl http://stapp01:5000
