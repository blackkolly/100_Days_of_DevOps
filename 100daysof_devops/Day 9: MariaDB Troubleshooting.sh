There is a critical issue going on with the Nautilus application in Stratos DC. The production support team identified that the application is unable to connect to the database. After digging into the issue, the team found that mariadb service is down on the database server.

Look into the issue and fix the same.

1. Connect to DB server

From the jump host:

ssh peter@stdb01.stratos.xfusioncorp.com
Password: Sp!dy

2. Check MariaDB service status
sudo systemctl status mariadb
Possible states:
inactive (dead) → needs to be started.
failed → crashed due to configuration or corruption.Step 
3: Check logs to identify the issue
# Check the last 30 lines of MariaDB log
sudo tail -30 /var/log/mariadb/mariadb.log

# Check systemd journal for MariaDB
sudo journalctl -xeu mariadb --no-pager | tail -30
From these logs, we saw permission denied errors (OS error 13).

Step 4: Fix ownership and permissions
sudo chown -R mysql:mysql /var/lib/mysql
sudo chmod 750 /var/lib/mysql

Step 5: Clean up stale files
sudo rm -f /var/lib/mysql/ibtmp1
sudo rm -f /var/lib/mysql/*.pid
sudo rm -f /var/lib/mysql/*.sock

Step 6: Restore SELinux labels
sudo restorecon -Rv /var/lib/mysql

Step 7: Restart and enable MariaDB
sudo systemctl restart mariadb
sudo systemctl enable mariadb
sudo systemctl status mariadb --no-pager

Step 8: Verify service is running
# Check if MariaDB is listening on port 3306
sudo ss -tulnp | grep 3306

# Test login to MariaDB
mysql -u root -p

# Confirm service is enabled at boot
sudo systemctl is-enabled mariadb

