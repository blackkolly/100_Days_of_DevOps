The devops team of xFusionCorp Industries is working on to setup centralised logging management system to maintain and analyse server logs easily. 
Since it will take some time to implement, they wanted to gather some server logs on a regular basis. At least one of the app servers is having issues with 
the Apache server. The team needs Apache logs so that they can identify and troubleshoot the issues easily if they arise. So they decided to create a Jenkins 
job to collect logs from the server. Please create/configure a Jenkins job as per details mentioned below:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321

1. Create a Jenkins jobs named copy-logs.

2. Configure it to periodically build every 5 minutes to copy the Apache logs (both access_log and error_logs) from App Server 2 (from default logs location) 
to location /usr/src/dba on Storage Server.
Note:
1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no 
jobs are running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. 
In this case please make sure to refresh the UI page.
2. Please make sure to define you cron expression like this */10 * * * * (this is just an example to run job every 10 minutes).
3. For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your 
task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.


Perfect — this task is about setting up a **Jenkins job (`copy-logs`)** that automatically copies Apache logs from **App Server 1** to the **Storage Server** every 8 minutes.

Let’s go step-by-step so you can perform it cleanly in the Jenkins UI 👇

---

### 🧩 **Objective Recap**

You need to:

* Create a Jenkins job called **`copy-logs`**
* Run every **8 minutes** (`*/8 * * * *`)
* Copy both **`access_log`** and **`error_log`** from **App Server 1 (stapp01)** → **Storage Server (ststor01)** under `/usr/src/devops`
* Use Jenkins user: `jenkins` (host: `jenkins.stratos.xfusioncorp.com`)
* Ensure the job runs non-interactively (i.e., with SSH key or passwordless SSH between Jenkins and the servers)


1. Log into Jenkins**

URL: `http://jenkins.stratos.xfusioncorp.com:8080/`
Username: `admin`
Password: `Adm!n321`

2. Create a New Job

Click New Item
Enter item name: `copy-logs`
Select Freestyle project
Click OK


3. Configure Build Triggers

 Go to Build Triggers
 Check Build periodically
 In the schedule box, add:


  */8 * * * *
 

  ➜ runs every 8 minutes

4. Configure Build Step

You’ll copy logs using an SSH or shell script.

Under Build → Add build step → Execute shell, add this script:

```bash
#!/bin/bash

# Variables
APP_SERVER="172.16.238.10"
APP_USER="tony"
APP_PASS="Ir0nM@n"
STORAGE_SERVER="172.16.238.15"
STORAGE_USER="natasha"
STORAGE_PASS="Bl@kW"

# Remote log paths (Apache default)
LOG_DIR="/var/log/httpd"
ACCESS_LOG="$LOG_DIR/access_log"
ERROR_LOG="$LOG_DIR/error_log"

# Destination on storage server
DEST_DIR="/usr/src/devops"

# Use sshpass for non-interactive copying
yum install -y sshpass > /dev/null 2>&1

# Create destination directory if not present
sshpass -p "$STORAGE_PASS" ssh -o StrictHostKeyChecking=no $STORAGE_USER@$STORAGE_SERVER "mkdir -p $DEST_DIR"

# Copy logs from app server to Jenkins workspace
sshpass -p "$APP_PASS" scp -o StrictHostKeyChecking=no $APP_USER@$APP_SERVER:$ACCESS_LOG /tmp/
sshpass -p "$APP_PASS" scp -o StrictHostKeyChecking=no $APP_USER@$APP_SERVER:$ERROR_LOG /tmp/

# Copy logs from Jenkins to storage server
sshpass -p "$STORAGE_PASS" scp -o StrictHostKeyChecking=no /tmp/access_log /tmp/error_log $STORAGE_USER@$STORAGE_SERVER:$DEST_DIR/

5. Apply and Save

* Click Apply and Save
* Optionally test by clicking Build Now once to verify connectivity and copy.


6. Verify Logs

On Storage Server (ststor01):

ssh natasha@172.16.238.15
cd /usr/src/devops
ls -l

You should see:

access_log
error_log


