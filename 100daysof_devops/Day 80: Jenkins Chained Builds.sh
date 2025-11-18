The DevOps team was looking for a solution where they want to restart Apache service on all app servers if the deployment goes fine on these servers in Stratos Datacenter. After having a discussion, they came up with a solution to use Jenkins chained builds so that they can use a downstream job for services which should only be triggered by the deployment job. So as per the requirements mentioned below configure the required Jenkins jobs.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and Adm!n321 password.

Similarly you can access Gitea UI on port 8090 and username and password for Git is sarah and Sarah_pass123 respectively. Under user sarah you will find a repository named web.

Apache is already installed and configured on all app server so no changes are needed there. The doc root /var/www/html on all these app servers is shared among the Storage server under /var/www/html directory.

Create a Jenkins job named nautilus-app-deployment and configure it to pull change from the master branch of web repository on Storage server under /var/www/html directory, which is already a local git repository tracking the origin web repository. Since /var/www/html on Storage server is a shared volume so changes should auto reflect on all apps.
Create another Jenkins job named manage-services and make it a downstream job for nautilus-app-deployment job. Things to take care about this job are:
a. This job should restart httpd service on all app servers.

b. Trigger this job only if the upstream job i.e nautilus-app-deployment is stable.

LB server is already configured. Click on the App button on the top bar to access the app. You should be able to see the latest changes you made. Please make sure the required content is loading on the main URL https://<LBR-URL> i.e there should not be a sub-directory like https://<LBR-URL>/web etc.

Note:

You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also some times Jenkins UI gets stuck when Jenkins service restarts in the back end so in such case please make sure to refresh the UI page.
Make sure Jenkins job passes even on repetitive runs as validation may try to build the job multiple times.
Deployment related tasks should be done by sudo user on the destination server to avoid any permission issues so make sure to configure your Jenkins job accordingly.
For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.


# Jenkins Chained Builds - Complete Solution Guide

## Overview
This guide configures Jenkins chained builds for automated deployment and Apache service management across the Nautilus/Stratos infrastructure.

## Prerequisites
- Access to Jenkins UI (admin/Adm!n321)
- Access to Gitea UI on port 8090 (sarah/Sarah_pass123)
- SSH access to all servers from jump host
- Apache installed on all app servers
- Shared storage mounted at /var/www/html

## Infrastructure Details

| Server | IP | Hostname | User | Password | Purpose |
|--------|-------|----------|------|----------|---------|
| stapp01 | 172.16.238.10 | stapp01.stratos.xfusioncorp.com | tony | Ir0nM@n | Nautilus App 1 |
| stapp02 | 172.16.238.11 | stapp02.stratos.xfusioncorp.com | steve | Am3ric@ | Nautilus App 2 |
| stapp03 | 172.16.238.12 | stapp03.stratos.xfusioncorp.com | banner | BigGr33n | Nautilus App 3 |
| ststor01 | 172.16.238.15 | ststor01.stratos.xfusioncorp.com | natasha | Bl@kW | Nautilus Storage |
| jenkins | 172.16.238.19 | jenkins.stratos.xfusioncorp.com | jenkins | j@rv!s | Jenkins CI/CD |

---

## Part 1: Configure Passwordless Sudo on All Servers

### Step 1.1: Configure Storage Server (ststor01)

SSH into the storage server and configure passwordless sudo for natasha:

```bash
# From jump host
ssh natasha@ststor01
# Password: Bl@kW

# Configure passwordless sudo
echo 'Bl@kW' | sudo -S bash -c "echo 'natasha ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/natasha"
echo 'Bl@kW' | sudo -S chmod 0440 /etc/sudoers.d/natasha

# Test it works
sudo ls -la /var/www/html

# Exit
exit
```

### Step 1.2: Configure App Server 1 (stapp01)

```bash
# From jump host
ssh tony@stapp01
# Password: Ir0nM@n

# Configure passwordless sudo for systemctl
echo 'Ir0nM@n' | sudo -S bash -c "echo 'tony ALL=(ALL) NOPASSWD: /bin/systemctl' > /etc/sudoers.d/tony"
echo 'Ir0nM@n' | sudo -S chmod 0440 /etc/sudoers.d/tony

# Test it works
sudo systemctl status httpd

# Exit
exit
```

### Step 1.3: Configure App Server 2 (stapp02)

```bash
# From jump host
ssh steve@stapp02
# Password: Am3ric@

# Configure passwordless sudo for systemctl
echo 'Am3ric@' | sudo -S bash -c "echo 'steve ALL=(ALL) NOPASSWD: /bin/systemctl' > /etc/sudoers.d/steve"
echo 'Am3ric@' | sudo -S chmod 0440 /etc/sudoers.d/steve

# Test it works
sudo systemctl status httpd

# Exit
exit
```

### Step 1.4: Configure App Server 3 (stapp03)

```bash
# From jump host
ssh banner@stapp03
# Password: BigGr33n

# Configure passwordless sudo for systemctl
echo 'BigGr33n' | sudo -S bash -c "echo 'banner ALL=(ALL) NOPASSWD: /bin/systemctl' > /etc/sudoers.d/banner"
echo 'BigGr33n' | sudo -S chmod 0440 /etc/sudoers.d/banner

# Test it works
sudo systemctl status httpd

# Exit
exit
```

### Step 1.5: Verify Passwordless Sudo from Jump Host

```bash
# Test storage server
sshpass -p 'Bl@kW' ssh -o StrictHostKeyChecking=no natasha@ststor01 "sudo ls -la /var/www/html"

# Test app servers
sshpass -p 'Ir0nM@n' ssh -o StrictHostKeyChecking=no tony@stapp01 "sudo systemctl status httpd"
sshpass -p 'Am3ric@' ssh -o StrictHostKeyChecking=no steve@stapp02 "sudo systemctl status httpd"
sshpass -p 'BigGr33n' ssh -o StrictHostKeyChecking=no banner@stapp03 "sudo systemctl status httpd"
```

If these commands work without password prompts, proceed to the next part.

---

## Part 2: Configure Jenkins

### Step 2.1: Access Jenkins

1. Click on the **Jenkins** button in the top bar
2. Login with:
   - Username: `admin`
   - Password: `Adm!n321`

### Step 2.2: Install Required Plugins (if needed)

1. Go to **Manage Jenkins** → **Manage Plugins**
2. Click **Available** tab
3. Search and install if not present:
   - **Git Plugin**
   - **SSH Agent Plugin** (optional)
4. Check **"Restart Jenkins when installation is complete and no jobs are running"**
5. Wait for Jenkins to restart and login again

---

## Part 3: Create Jenkins Credentials

### Step 3.1: Add Git Credentials

1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click on **(global)** domain
3. Click **Add Credentials**
4. Configure:
   - **Kind**: Username with password
   - **Scope**: Global
   - **Username**: `sarah`
   - **Password**: `Sarah_pass123`
   - **ID**: `gitea-sarah`
   - **Description**: `Gitea Sarah Credentials`
5. Click **OK**

---

## Part 4: Create the Deployment Job (nautilus-app-deployment)

### Step 4.1: Create New Job

1. From Jenkins Dashboard, click **New Item**
2. Enter name: `nautilus-app-deployment`
3. Select **Freestyle project**
4. Click **OK**

### Step 4.2: Configure General Settings

- **Description**: `Deploy web application from Git to shared storage`

### Step 4.3: Configure Source Code Management

1. Select **Git**
2. **Repository URL**: `http://git.stratos.xfusioncorp.com/sarah/web.git`
3. **Credentials**: Select `sarah/****** (Gitea Sarah Credentials)`
4. **Branch Specifier**: `*/master`

### Step 4.4: Configure Build Environment

Leave this section empty (no checkboxes needed)

### Step 4.5: Configure Build Steps

1. Click **Add build step** → **Execute shell**
2. Enter the following script:

```bash
#!/bin/bash
set -e

echo "Starting deployment from Jenkins workspace to storage server..."

# Prepare storage server
sshpass -p 'Bl@kW' ssh -o StrictHostKeyChecking=no natasha@ststor01 "sudo rm -rf /tmp/web_deploy && mkdir -p /tmp/web_deploy"

# Copy all files from Jenkins workspace
echo "Copying files to storage server..."
sshpass -p 'Bl@kW' scp -o StrictHostKeyChecking=no -r ${WORKSPACE}/* natasha@ststor01:/tmp/web_deploy/

# Deploy and configure
echo "Deploying to /var/www/html..."
sshpass -p 'Bl@kW' ssh -o StrictHostKeyChecking=no natasha@ststor01 "sudo rm -rf /var/www/html/* && sudo rm -rf /var/www/html/.git* && sudo cp -r /tmp/web_deploy/* /var/www/html/ && sudo chmod -R 755 /var/www/html && rm -rf /tmp/web_deploy && echo 'Deployment complete' && sudo ls -la /var/www/html"

echo "Deployment finished successfully!"
```

### Step 4.6: Configure Post-build Actions

1. Click **Add post-build action** → **Build other projects**
2. **Projects to build**: `manage-services`
3. **Check**: ✅ **Trigger only if build is stable**
4. Click **Save**

---

## Part 5: Create the Service Management Job (manage-services)

### Step 5.1: Create New Job

1. From Jenkins Dashboard, click **New Item**
2. Enter name: `manage-services`
3. Select **Freestyle project**
4. Click **OK**

### Step 5.2: Configure General Settings

- **Description**: `Restart Apache service on all app servers`

### Step 5.3: Configure Source Code Management

- Select **None**

### Step 5.4: Configure Build Environment

Leave this section empty

### Step 5.5: Configure Build Steps

1. Click **Add build step** → **Execute shell**
2. Enter the following script:

```bash
#!/bin/bash
set -e

echo "Restarting Apache on all app servers..."

# Restart Apache on stapp01
echo "========================================="
echo "Restarting Apache on stapp01..."
echo "========================================="
sshpass -p 'Ir0nM@n' ssh -o StrictHostKeyChecking=no tony@stapp01 "sudo systemctl restart httpd && sudo systemctl status httpd --no-pager"

# Restart Apache on stapp02
echo "========================================="
echo "Restarting Apache on stapp02..."
echo "========================================="
sshpass -p 'Am3ric@' ssh -o StrictHostKeyChecking=no steve@stapp02 "sudo systemctl restart httpd && sudo systemctl status httpd --no-pager"

# Restart Apache on stapp03
echo "========================================="
echo "Restarting Apache on stapp03..."
echo "========================================="
sshpass -p 'BigGr33n' ssh -o StrictHostKeyChecking=no banner@stapp03 "sudo systemctl restart httpd && sudo systemctl status httpd --no-pager"

echo "========================================="
echo "Apache restarted successfully on all app servers!"
echo "========================================="
```

### Step 5.6: Save Configuration

Click **Save**

---

## Part 6: Test the Pipeline

### Step 6.1: Trigger Manual Build

1. Go to the **nautilus-app-deployment** job
2. Click **Build Now**
3. Watch the build progress in **Build History**
4. Click on the build number (e.g., #1)
5. Click **Console Output** to view logs

### Step 6.2: Verify Build Success

Check the console output for:
- ✅ Git clone successful
- ✅ Files copied to storage server
- ✅ Deployment completed successfully
- ✅ Triggering manage-services job

### Step 6.3: Verify Downstream Job

1. Go to the **manage-services** job
2. You should see it was automatically triggered
3. Check **Console Output** for:
   - ✅ Apache restarted on stapp01
   - ✅ Apache restarted on stapp02
   - ✅ Apache restarted on stapp03
   - ✅ All services showing as active/running

### Step 6.4: Verify Application

1. Click the **App** button in the top bar
2. Verify the web application loads correctly
3. Ensure the URL is `https://<LBR-URL>` (no /web subdirectory)
4. Verify content from the Git repository is displayed

---

## Part 7: Test Repeated Builds

### Step 7.1: Run Multiple Builds

1. Go back to **nautilus-app-deployment**
2. Click **Build Now** multiple times
3. Verify each build:
   - Completes successfully
   - Triggers the downstream job
   - Doesn't fail due to existing files or permissions

### Step 7.2: Make a Change in Git

1. Access Gitea UI on port 8090
2. Login with sarah/Sarah_pass123
3. Navigate to the **web** repository
4. Edit a file (e.g., index.html)
5. Commit the change
6. Go to Jenkins and build **nautilus-app-deployment**
7. Verify the changes appear in the application

