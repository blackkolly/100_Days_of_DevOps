There is a requirement to create a Jenkins job to automate the database backup. Below you can find more details to accomplish this task:
Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.
Create a Jenkins job named database-backup.
Configure it to take a database dump of the kodekloud_db01 database present on the Database server in Stratos Datacenter, the database user is kodekloud_roy
and password is asdfgdsd.
The dump should be named in db_$(date +%F).sql format, where date +%F is the current date.
Copy the db_$(date +%F).sql dump to the Backup Server under location /home/clint/db_backups.

Further, schedule this job to run periodically at */10 * * * * (please use this exact schedule format).

Note:
You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are 
running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case 
please make sure to refresh the UI page.

Please make sure to define you cron expression like this */10 * * * * (this is just an example to run job every 10 minutes).

For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task 
is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.



Step-by-Step Setup

1. Login to Jenkins

 Go to Jenkins UI
  → `http://jenkins.stratos.xfusioncorp.com:8080`
 Username: `admin`
 Password: `Adm!n321`


2. Create the Jenkins Job

Click New Item
Enter item name: `database-backup`
Select Freestyle project
Click OK

3. Configure the Build Trigger

Scroll to Build Triggers
Check Build periodically
In the Schedule box, enter:

  */10 * * * *

  ➜ This runs every 10 minutes.



4. Add the Build Step

Go to Build → “Add build step” → “Execute shell

Paste the following script:

```bash
#!/bin/bash

# Variables
DB_HOST="172.16.239.10"
DB_USER="kodekloud_roy"
DB_PASS="asdfgdsd"
DB_NAME="kodekloud_db01"
BACKUP_SERVER="172.16.238.16"
BACKUP_USER="clint"
BACKUP_PASS="H@wk3y3"
DEST_DIR="/home/clint/db_backups"
DATE=$(date +%F)
BACKUP_FILE="db_${DATE}.sql"

# Install sshpass if not available
yum install -y sshpass > /dev/null 2>&1

# Take MySQL dump on Jenkins server
mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME > /tmp/$BACKUP_FILE

# Verify dump created
if [ ! -f /tmp/$BACKUP_FILE ]; then
  echo "Database dump failed!"
  exit 1
fi

# Copy dump to Backup Server
sshpass -p "$BACKUP_PASS" scp -o StrictHostKeyChecking=no /tmp/$BACKUP_FILE $BACKUP_USER@$BACKUP_SERVER:$DEST_DIR/

# Cleanup temp file
rm -f /tmp/$BACKUP_FILE

echo "Backup completed and copied to $DEST_DIR on Backup Server.

5. Apply & Save

Click Apply → Save
You can also click **“Build Now”** once to test manually.

---

6. Verify the Backup

SSH into the Backup Server:

ssh clint@172.16.238.16
ls -l /home/clint/db_backups

You should see a file like:

db_2025-11-12.sql

