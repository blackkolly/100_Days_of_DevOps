The Nautilus development team had a meeting with the DevOps team where they discussed automating the deployment of one of their apps using Jenkins (the one in Stratos Datacenter). They want to auto deploy the new changes in case any developer pushes to the repository. As per the requirements mentioned below configure the required Jenkins job.
Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and Adm!n321 password.
Similarly, you can access the Gitea UI using Gitea button, username and password for Git is sarah and Sarah_pass123 respectively. Under user sarah you will find a repository named web that is already cloned on the Storage server under sarah's home. sarah is a developer who is working on this repository.
1. Install httpd (whatever version is available in the yum repo by default) and configure it to serve on port 8080 on All app servers. You can make it part of your Jenkins job or you can do this step manually on all app servers.
2. Create a Jenkins job named nautilus-app-deployment and configure it in a way so that if anyone pushes any new change to the origin repository in master branch, the job should auto build and deploy the latest code on the Storage server under /var/www/html directory. Since /var/www/html on Storage server is shared among all apps. Before deployment, ensure that the ownership of the /var/www/html directory is set to user sarah, so that Jenkins can successfully deploy files to that directory.
3. SSH into Storage Server using sarah user credentials mentioned above. Under sarah user's home you will find a cloned Git repository named web. Under this repository there is an index.html file, update its content to Welcome to the xFusionCorp Industries, then push the changes to the origin into master branch. This push must trigger your Jenkins job and the latest changes must be deployed on the servers, also make sure it deploys the entire repository content not only index.html file.
Click on the App button on the top bar to access the app, you should be able to see the latest changes you deployed. Please make sure the required content is loading on the main URL https://<LBR-URL> i.e there should not be any sub-directory like https://<LBR-URL>/web etc.
Note: 1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also some times Jenkins UI gets stuck when Jenkins service restarts in the back end so in such case please make sure to refresh the UI page.
2. Make sure Jenkins job passes even on repetitive runs as validation may try to build the job multiple times.
3. Deployment related tasks should be done by sudo user on the destination server to avoid any permission issues so make sure to configure your Jenkins job accordingly.
4. For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.





# Nautilus App Auto-Deployment Setup Guide

## Phase 1: Install and Configure httpd on App Servers

### Step 1.1: SSH into each app server and install httpd

```bash
# From jump_host, SSH to stapp01
ssh tony@stapp01.stratos.xfusioncorp.com
# Password: Ir0nM@n

# Install httpd
sudo yum install httpd -y

# Configure httpd to listen on port 8080
sudo sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf

# Start and enable httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Verify it's running on port 8080
sudo netstat -tlnp | grep 8080
# OR
sudo ss -tlnp | grep 8080

# Exit
exit
```

**Repeat for stapp02 (steve/Am3ric@) and stapp03 (banner/BigGr33n)**

```bash
# stapp02
ssh steve@stapp02.stratos.xfusioncorp.com
sudo yum install httpd -y
sudo sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
sudo systemctl start httpd
sudo systemctl enable httpd
exit

# stapp03
ssh banner@stapp03.stratos.xfusioncorp.com
sudo yum install httpd -y
sudo sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
sudo systemctl start httpd
sudo systemctl enable httpd
exit
```

## Phase 2: Prepare Storage Server

### Step 2.1: Configure /var/www/html ownership

```bash
# SSH to storage server
ssh natasha@ststor01.stratos.xfusioncorp.com
# Password: Bl@kW

# Set ownership of /var/www/html to sarah
sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html

# Verify
ls -ld /var/www/html

# Exit
exit
```

### Step 2.2: Configure Git repository

```bash
# SSH as sarah to storage server
ssh sarah@ststor01.stratos.xfusioncorp.com
# Password: Sarah_pass123

# Navigate to the web repository
cd ~/web

# Configure git user (if not already done)
git config --global user.name "sarah"
git config --global user.email "sarah@stratos.xfusioncorp.com"

# Check current content
cat index.html

# Update index.html
echo "Welcome to the xFusionCorp Industries" > index.html

# Verify the change
cat index.html

# DON'T PUSH YET - we'll do this after Jenkins is configured
# Just stage the changes for now
git add index.html
git status

# Exit (we'll come back to push later)
exit
```

## Phase 3: Configure Jenkins

### Step 3.1: Install Required Jenkins Plugins

1. Access Jenkins UI (admin/Adm!n321)
2. Go to **Manage Jenkins** → **Manage Plugins**
3. Click on **Available** tab
4. Search and install these plugins:
   - **Git plugin** (if not already installed)
   - **Gitea plugin** (for Gitea integration)
   - **Publish Over SSH** (for deploying to remote servers)
   - **SSH Agent** (for SSH operations)

5. Check "Restart Jenkins when installation is complete and no jobs are running"
6. Wait for Jenkins to restart (refresh the page after a minute)

### Step 3.2: Configure SSH Credentials for Storage Server

1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click on **(global)** domain
3. Click **Add Credentials**
4. Configure:
   - **Kind**: SSH Username with private key
   - **ID**: `storage-server-sarah`
   - **Description**: Sarah on Storage Server
   - **Username**: `sarah`
   - **Private Key**: Click "Enter directly"

**Generate SSH key on jump_host in PEM format (compatible with older libcrypto):**

```bash
# On jump_host
ssh-keygen -t rsa -b 2048 -m PEM -f /tmp/sarah_key -N ""

# IMPORTANT: Use -m PEM flag to generate in PEM format for compatibility

# Copy public key to storage server
ssh-copy-id -i /tmp/sarah_key.pub sarah@ststor01.stratos.xfusioncorp.com
# Password: Sarah_pass123

# Display private key to copy into Jenkins
cat /tmp/sarah_key
```

5. Copy the private key content (including the BEGIN and END lines) and paste into Jenkins
6. Click **Create**

**ALTERNATIVE: If still having issues, use Username/Password instead of SSH key:**

1. **Manage Jenkins** → **Manage Credentials** → **(global)**
2. **Add Credentials**:
   - **Kind**: Username with password
   - **Username**: `sarah`
   - **Password**: `Sarah_pass123`
   - **ID**: `storage-server-sarah`
   - **Description**: Sarah on Storage Server
3. Click **Create**

### Step 3.3: Configure Git Credentials

1. **Manage Jenkins** → **Manage Credentials** → **(global)**
2. **Add Credentials**:
   - **Kind**: Username with password
   - **Username**: `sarah`
   - **Password**: `Sarah_pass123`
   - **ID**: `gitea-sarah`
   - **Description**: Gitea Sarah User

### Step 3.4: Create Jenkins Job

1. From Jenkins dashboard, click **New Item**
2. Enter job name: `nautilus-app-deployment`
3. Select **Freestyle project**
4. Click **OK**

#### General Configuration:
- **Description**: Auto-deploy web application from Gitea to Storage Server

#### Source Code Management:
- Select **Git**
- **Repository URL**: `http://git.stratos.xfusioncorp.com/sarah/web.git`
  - (Check Gitea UI for exact URL - click on the web repository)
- **Credentials**: Select `sarah/****** (Gitea Sarah User)`
- **Branch Specifier**: `*/master`

#### Build Triggers:
- Check **Poll SCM**
- **Schedule**: `* * * * *` (polls every minute - for production use H/5 * * * *)

OR (Better option):
- Check **Generic Webhook Trigger** if plugin is available
- Otherwise, polling will work fine

#### Build Environment:
- **OPTION A (if SSH key works)**: Check **SSH Agent** and select credentials
- **OPTION B (recommended for compatibility)**: Use sshpass - see script below

#### Build Steps:

**Add Build Step** → **Execute shell**

**Script Option 1: Using sshpass (Most Compatible)**

```bash
#!/bin/bash
set -e

echo "Starting deployment process..."

# Define variables
STORAGE_SERVER="ststor01.stratos.xfusioncorp.com"
STORAGE_USER="sarah"
STORAGE_PASS="Sarah_pass123"
DEPLOY_PATH="/var/www/html"

# Show what we're deploying
echo "Deploying from workspace: $WORKSPACE"
ls -la

# Install sshpass if not available
if ! command -v sshpass &> /dev/null; then
    echo "Installing sshpass..."
    sudo yum install -y sshpass || sudo apt-get install -y sshpass
fi

# Create temp directory on storage server
echo "Preparing deployment directory..."
sshpass -p "${STORAGE_PASS}" ssh -o StrictHostKeyChecking=no ${STORAGE_USER}@${STORAGE_SERVER} << 'ENDSSH'
set -e
mkdir -p /tmp/deploy_temp
rm -rf /tmp/deploy_temp/*
echo "Temp directory prepared"
ENDSSH

# Copy all files from Jenkins workspace to storage server temp
echo "Copying files to storage server..."
sshpass -p "${STORAGE_PASS}" scp -o StrictHostKeyChecking=no -r ${WORKSPACE}/* ${STORAGE_USER}@${STORAGE_SERVER}:/tmp/deploy_temp/

# Deploy files with sudo and set permissions
echo "Deploying files to /var/www/html..."
sshpass -p "${STORAGE_PASS}" ssh -o StrictHostKeyChecking=no ${STORAGE_USER}@${STORAGE_SERVER} << 'ENDSSH'
set -e

echo "Cleaning deployment directory..."
sudo rm -rf /var/www/html/*

echo "Moving files to /var/www/html..."
sudo cp -r /tmp/deploy_temp/* /var/www/html/

echo "Setting ownership and permissions..."
sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html
sudo find /var/www/html -type f -exec chmod 644 {} \;

echo "Cleaning up temp files..."
rm -rf /tmp/deploy_temp

echo "Verifying deployment..."
ls -la /var/www/html/
echo "Content of index.html:"
cat /var/www/html/index.html

echo "Deployment completed successfully!"
ENDSSH

echo "Deployment finished!"
```

**Script Option 2: Using SSH key (if PEM format worked)**

```bash
#!/bin/bash
set -e

echo "Starting deployment process..."

# Define variables
STORAGE_SERVER="ststor01.stratos.xfusioncorp.com"
DEPLOY_PATH="/var/www/html"

# Show what we're deploying
echo "Deploying from workspace: $WORKSPACE"
ls -la

# SSH to storage server and deploy
ssh -o StrictHostKeyChecking=no sarah@${STORAGE_SERVER} << 'ENDSSH'
set -e

mkdir -p /tmp/deploy_temp
rm -rf /tmp/deploy_temp/*
echo "Temp directory prepared"
ENDSSH

# Copy files from Jenkins workspace to storage server
echo "Copying files to storage server..."
scp -o StrictHostKeyChecking=no -r ${WORKSPACE}/* sarah@${STORAGE_SERVER}:/tmp/deploy_temp/

# Move files to final destination with sudo
ssh -o StrictHostKeyChecking=no sarah@${STORAGE_SERVER} << 'ENDSSH'
set -e

echo "Cleaning deployment directory..."
sudo rm -rf /var/www/html/*

echo "Moving files to /var/www/html..."
sudo cp -r /tmp/deploy_temp/* /var/www/html/

echo "Setting permissions..."
sudo chown -R sarah:sarah /var/www/html
sudo chmod -R 755 /var/www/html
sudo find /var/www/html -type f -exec chmod 644 {} \;

echo "Cleaning up temp files..."
rm -rf /tmp/deploy_temp

echo "Verifying deployment..."
ls -la /var/www/html/
cat /var/www/html/index.html

echo "Deployment completed successfully!"
ENDSSH
```

5. Click **Save**

### Step 3.5: Configure Sarah's sudo permissions on Storage Server

```bash
# SSH to storage server as natasha (has sudo)
ssh natasha@ststor01.stratos.xfusioncorp.com
# Password: Bl@kW

# Add sarah to sudoers for specific commands
sudo visudo

# Add this line at the end:
sarah ALL=(ALL) NOPASSWD: /bin/cp, /bin/rm, /bin/chown, /bin/chmod, /bin/mkdir

# Or simply add sarah to wheel group if you prefer
# sudo usermod -aG wheel sarah

# Verify
sudo -l -U sarah

exit
```

## Phase 4: Test the Deployment

### Step 4.1: Manually trigger first build

1. In Jenkins, click on **nautilus-app-deployment** job
2. Click **Build Now**
3. Watch the **Console Output**
4. Ensure build succeeds

### Step 4.2: Test auto-trigger with git push

```bash
# SSH as sarah to storage server
ssh sarah@ststor01.stratos.xfusioncorp.com

cd ~/web

# If you haven't already updated index.html
echo "Welcome to the xFusionCorp Industries" > index.html

# Add and commit
git add index.html
git commit -m "Update welcome message"

# Push to origin master
git push origin master
# Username: sarah
# Password: Sarah_pass123

# Exit
exit
```

### Step 4.3: Verify Deployment

1. Watch Jenkins dashboard - job should trigger automatically within 1 minute
2. Check Console Output for successful deployment
3. Verify on storage server:

```bash
ssh sarah@ststor01.stratos.xfusioncorp.com
cat /var/www/html/index.html
# Should show: Welcome to the xFusionCorp Industries
exit
```

4. Check the app through LB:
   - Click **App** button or access via browser
   - Should display: "Welcome to the xFusionCorp Industries"

## Phase 5: Verification Checklist

- [ ] httpd installed and running on port 8080 on all 3 app servers
- [ ] /var/www/html owned by sarah on storage server
- [ ] Jenkins job `nautilus-app-deployment` created
- [ ] Git credentials configured in Jenkins
- [ ] SSH credentials configured in Jenkins
- [ ] Job triggers on git push to master
- [ ] Deployment script copies ALL files (not just index.html)
- [ ] App accessible via LB showing correct content
- [ ] Job passes on repeated runs

## Troubleshooting

### SSH Key Issues (Error loading key / libcrypto error):

**Solution 1: Use PEM format key**
```bash
# Generate key in PEM format
ssh-keygen -t rsa -b 2048 -m PEM -f /tmp/sarah_key -N ""

# Copy to storage server
ssh-copy-id -i /tmp/sarah_key.pub sarah@ststor01.stratos.xfusioncorp.com

# Use this private key in Jenkins
cat /tmp/sarah_key
```

**Solution 2: Use sshpass (Recommended)**
- Don't use SSH Agent credential binding
- Use Script Option 1 from the guide (with sshpass)
- Install sshpass on Jenkins server:
```bash
ssh jenkins@jenkins.stratos.xfusioncorp.com
sudo yum install -y sshpass
exit
```

**Solution 3: Store password as secret text**
1. In Jenkins, **Manage Credentials** → Add Credentials
2. Kind: **Secret text**
3. Secret: `Sarah_pass123`
4. ID: `sarah-password`
5. Use in script:
```bash
#!/bin/bash
STORAGE_PASS="${SARAH_PASSWORD}"  # Jenkins injects this
sshpass -p "${STORAGE_PASS}" ssh sarah@ststor01...
```
6. In Build Environment, check **Use secret text(s) or file(s)**
7. Add binding: Variable: `SARAH_PASSWORD`, Credentials: `sarah-password`

### If httpd not accessible:
```bash
sudo systemctl status httpd
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

### If SSH fails from Jenkins:
- Check SSH key is correctly added
- Verify ssh-copy-id worked
- Test manual SSH from jump_host

### If deployment fails:
- Check sarah's sudo permissions
- Verify /var/www/html ownership
- Check Jenkins console output for errors

### If git push doesn't trigger build:
- Verify polling is enabled (* * * * *)
- Check Jenkins system log
- Manually trigger once to verify job works

### If files don't appear on LB:
- Verify all app servers mount /var/www/html from storage
- Check httpd is serving correct DocumentRoot
- Verify file permissions (755 for dirs, 644 for files)

## Alternative: Using Gitea Webhook (More Efficient)

Instead of polling, you can configure a webhook:

1. In Gitea UI, go to repository **Settings** → **Webhooks**
2. Add webhook:
   - **Target URL**: `http://jenkins.stratos.xfusioncorp.com:8080/git/notifyCommit?url=http://git.stratos.xfusioncorp.com/sarah/web.git`
3. In Jenkins job, remove polling and use webhook trigger instead

---

## Quick Reference Commands

```bash
# Check httpd status on app servers
sudo systemctl status httpd
curl localhost:8080

# Verify storage mount on app servers
df -h | grep www
mount | grep www

# Check deployment on storage
ssh sarah@ststor01 "ls -la /var/www/html"

# View Jenkins logs
ssh jenkins@jenkins.stratos.xfusioncorp.com
sudo tail -f /var/log/jenkins/jenkins.log

# Test git operations
cd ~/web
git status
git log --oneline
```
