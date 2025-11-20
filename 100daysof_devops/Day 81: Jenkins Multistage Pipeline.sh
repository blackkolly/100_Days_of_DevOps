The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a Jenkins pipeline job. Please find below more details about the task:



Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.


Similarly, click on the Gitea button on the top bar to access the Gitea UI. Login using username sarah and password Sarah_pass123.


There is a repository named sarah/web in Gitea that is already cloned on Storage server under /var/www/html directory.


Update the content of the file index.html under the same repository to Welcome to xFusionCorp Industries and push the changes to the origin into the master branch.


Apache is already installed on all app Servers its running on port 8080.


Create a Jenkins pipeline job named deploy-job (it must not be a Multibranch pipeline job) and pipeline should have two stages Deploy and Test ( names are case sensitive ). Configure these stages as per details mentioned below.


a. The Deploy stage should deploy the code from web repository under /var/www/html on the Storage Server, as this location is already mounted to the document root /var/www/html of all app servers.


b. The Test stage should just test if the app is working fine and website is accessible. Its up to you how you design this stage to test it out, you can simply add a curl command as well to run a curl against the LBR URL (http://stlb01:8091) to see if the website is working or not. Make sure this stage fails in case the website/app is not working or if the Deploy stage fails.


Click on the App button on the top bar to see the latest changes you deployed. Please make sure the required content is loading on the main URL http://stlb01:8091 i.e there should not be a sub-directory like http://stlb01:8091/web etc.


Note:


You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, please make sure to refresh the UI page.


For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.







# Complete Solution: Jenkins Pipeline Deployment for xFusionCorp Industries

## Step 1: Update index.html in Gitea Repository

SSH to the Storage Server and update the repository:

```bash
# From jump host, SSH to storage server
ssh natasha@ststor01.stratos.xfusioncorp.com
# Password: Bl@kW

# Navigate to the repository
cd /var/www/html

# Update the file
sudo vi index.html
```

Replace the entire content with:
```html
Welcome to xFusionCorp Industries
```

Save and exit (`:wq`).

Commit and push the changes:

```bash
# Fix permissions
sudo chown -R natasha:natasha /var/www/html

# Configure git
git config user.email "sarah@stratos.xfusioncorp.com"
git config user.name "sarah"

# Add, commit and push
git add index.html
git commit -m "Update welcome message"
git push origin master
```

**Credentials when prompted:**
- Username: `sarah`
- Password: `Sarah_pass123`

Exit the storage server:
```bash
exit
```

## Step 2: Setup SSH Access from Jenkins to Storage Server

SSH to Jenkins server:

```bash
# From jump host, SSH to Jenkins server
ssh jenkins@jenkins.stratos.xfusioncorp.com
# Password: j@rv!s

# Generate SSH key pair
ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa

# Display the public key
cat ~/.ssh/id_rsa.pub
```

**Copy the entire public key output.**

Open a **new terminal** and add the key to storage server:

```bash
# SSH to storage server
ssh natasha@ststor01.stratos.xfusioncorp.com
# Password: Bl@kW

# Create .ssh directory if needed
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Add Jenkins public key (paste the key you copied)
echo "PASTE_JENKINS_PUBLIC_KEY_HERE" >> ~/.ssh/authorized_keys

# Set correct permissions
chmod 600 ~/.ssh/authorized_keys

# Exit
exit
```

Back on Jenkins server, test the connection:

```bash
# Test SSH (should work without password)
ssh -o StrictHostKeyChecking=no natasha@ststor01 'echo "SSH works"'

# Test git command
ssh -o StrictHostKeyChecking=no natasha@ststor01 'cd /var/www/html && git status'

# Exit Jenkins server
exit
```

## Step 3: Create Jenkins Pipeline Job

### Delete Existing Job (if it exists)

1. **Access Jenkins UI** (click Jenkins button)
   - Username: `admin`
   - Password: `Adm!n321`

2. If `deploy-job` exists:
   - Click on `deploy-job`
   - Click **"Delete Pipeline"** (left sidebar)
   - Confirm deletion

### Create New Pipeline Job

1. Click **"New Item"** (top left of dashboard)

2. **Enter item name:** `deploy-job`

3. **Select job type:** Click on **"Pipeline"** (NOT "Multibranch Pipeline")
   ```
   ○ Freestyle project
   ○ Pipeline              ← SELECT THIS ONE
   ○ Multi-configuration project
   ○ Folder
   ○ Multibranch Pipeline  ← NOT THIS
   ```

4. Click **"OK"**

### Configure Pipeline Script

1. Scroll down to the **"Pipeline"** section

2. In **"Definition"** dropdown, ensure: **"Pipeline script"**

3. In the **Script** text box, paste:

```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy') {
            steps {
                script {
                    echo "========== Starting Deploy Stage =========="
                    
                    sh '''
                        ssh -o StrictHostKeyChecking=no natasha@ststor01 'cd /var/www/html && git fetch origin && git reset --hard origin/master'
                    '''
                    
                    echo "========== Deploy Stage Completed =========="
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo "========== Starting Test Stage =========="
                    
                    sh '''
                        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://stlb01:8091)
                        echo "HTTP Response Code: $HTTP_CODE"
                        
                        if [ "$HTTP_CODE" != "200" ]; then
                            echo "ERROR: Website returned HTTP $HTTP_CODE"
                            exit 1
                        fi
                        
                        echo "HTTP Status Check: PASSED"
                        
                        CONTENT=$(curl -s http://stlb01:8091)
                        echo "Content: $CONTENT"
                        
                        if echo "$CONTENT" | grep -q "Welcome to xFusionCorp Industries"; then
                            echo "Content Verification: PASSED"
                        else
                            echo "ERROR: Expected content not found"
                            exit 1
                        fi
                    '''
                    
                    echo "========== Test Stage Completed =========="
                }
            }
        }
    }
    
    post {
        success {
            echo "Pipeline Completed Successfully"
        }
        failure {
            echo "Pipeline Failed"
        }
    }
}
```

4. Click **"Save"**

## Step 4: Run the Pipeline

1. Click **"Build Now"** (left sidebar)

2. Watch the build progress:
   - Build number appears in "Build History"
   - **Stage View** appears showing "Deploy" and "Test" stages
   
3. Click on the build number (e.g., #1)

4. Click **"Console Output"** to see detailed logs

5. Verify both stages complete successfully with green checkmarks

## Step 5: Verify Deployment

1. Click the **"App"** button on the top bar

2. Verify the page displays:
   ```
   Welcome to xFusionCorp Industries
   ```

3. Or navigate directly to: `http://stlb01:8091`

## Troubleshooting

### If SSH fails in Deploy stage:

```bash
# Verify SSH key is properly set up
ssh jenkins@jenkins.stratos.xfusioncorp.com
ssh -o StrictHostKeyChecking=no natasha@ststor01 'pwd'
```

### If git pull fails due to permissions:

```bash
# On storage server
ssh natasha@ststor01.stratos.xfusioncorp.com
sudo chown -R natasha:natasha /var/www/html
cd /var/www/html
git status
```

### If Test stage fails with HTTP error:

```bash
# Check Apache is running on app servers
ssh tony@stapp01.stratos.xfusioncorp.com
sudo systemctl status httpd

# Check load balancer
curl -I http://stlb01:8091
```

### If content verification fails:

```bash
# Verify index.html content
ssh natasha@ststor01.stratos.xfusioncorp.com
cat /var/www/html/index.html

# Should show: Welcome to xFusionCorp Industries
```

### If stages don't appear (instant SUCCESS):

This means the pipeline script isn't executing. The job might be the wrong type or Jenkins needs restart:

```bash
# Restart Jenkins
ssh jenkins@jenkins.stratos.xfusioncorp.com
# You may need to ask an admin to restart Jenkins, or use the UI:
# Go to: http://jenkins-url/safeRestart
```

Or delete and recreate the job following Step 3 exactly.

## Verification Checklist

- ✅ `index.html` contains exactly: `Welcome to xFusionCorp Industries`
- ✅ Changes committed and pushed to Gitea master branch
- ✅ SSH works from Jenkins to Storage Server without password
- ✅ Jenkins job named exactly `deploy-job`
- ✅ Job type is "Pipeline" (not Multibranch or Freestyle)
- ✅ Pipeline has two stages: `Deploy` and `Test` (case-sensitive)
- ✅ Deploy stage pulls code using git reset --hard
- ✅ Test stage checks HTTP 200 and verifies content
- ✅ Test stage fails if website doesn't work
- ✅ Website loads at `http://stlb01:8091` with correct content
- ✅ Stage View shows both stages in Jenkins UI
- ✅ Console Output shows detailed execution logs

## Expected Console Output

When the pipeline runs successfully, you should see:

```
Started by user admin
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/lib/jenkins/workspace/deploy-job
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Deploy)
[Pipeline] script
[Pipeline] {
[Pipeline] echo
========== Starting Deploy Stage ==========
[Pipeline] sh
+ ssh -o StrictHostKeyChecking=no natasha@ststor01 cd /var/www/html && git fetch origin && git reset --hard origin/master
HEAD is now at abc1234 Update welcome message
[Pipeline] echo
========== Deploy Stage Completed ==========
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Test)
[Pipeline] script
[Pipeline] {
[Pipeline] echo
========== Starting Test Stage ==========
[Pipeline] sh
+ curl -s -o /dev/null -w %{http_code} http://stlb01:8091
+ echo HTTP Response Code: 200
HTTP Response Code: 200
+ echo HTTP Status Check: PASSED
HTTP Status Check: PASSED
+ curl -s http://stlb01:8091
+ echo Content: Welcome to xFusionCorp Industries
Content: Welcome to xFusionCorp Industries
+ echo Content Verification: PASSED
Content Verification: PASSED
[Pipeline] echo
========== Test Stage Completed ==========
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] echo
Pipeline Completed Successfully
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

Your deployment is now complete! 🎉
