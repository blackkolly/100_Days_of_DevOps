The Nautilus system admins team has prepared scripts to automate several day-to-day tasks. They want them to be deployed on all app servers in Stratos DC on a set schedule. Before that they need to test similar functionality with a sample cron job. Therefore, perform the steps below:
a. Install cronie package on all Nautilus app servers and start crond service.
b. Add a cron */5 * * * * echo hello > /tmp/cron_text for root user.
1. Connect to each App Server

ssh tony@stapp01.stratos.xfusioncorp.com   # password: Ir0nM@n
ssh steve@stapp02.stratos.xfusioncorp.com  # password: Am3ric@
ssh banner@stapp03.stratos.xfusioncorp.com # password: BigGr33n

2. Install `cronie` and start `crond

On each app server, run:


sudo yum install -y cronie
sudo systemctl enable crond
sudo systemctl start crond

Verify:
systemctl status crond
3. Add the cron job for root

Edit the root crontab
sudo crontab -e

Add this line at the bottom:
*/5 * * * * echo hello > /tmp/cron_text
Save and exit.

4. Verify the cron job is added

Check root’s crontab:
sudo crontab -l

Expected output:

*/5 * * * * echo hello > /tmp/cron_text


