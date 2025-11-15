The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly we need to create a 
Jenkins pipeline job. Please find below more details about the task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Similarly, click on the Gitea button on the top bar to access the Gitea UI. Login using username sarah and password Sarah_pass123. There under user sarah you 
will find a repository named web_app that is already cloned on Storage server under /var/www/html. sarah is a developer who is working on this repository.

Add a slave node named Storage Server. It should be labeled as ststor01 and its remote root directory should be /var/www/html.

We have already cloned repository on Storage Server under /var/www/html.

Apache is already installed on all app Servers its running on port 8080.

Create a Jenkins pipeline job named xfusion-webapp-job (it must not be a Multibranch pipeline) and configure it to:

Deploy the code from web_app repository under /var/www/html on Storage Server, as this location is already mounted to the document root /var/www/html of app servers. 
The pipeline should have a single stage named Deploy ( which is case sensitive ) to accomplish the deployment.

LB server is already configured. You should be able to see the latest changes you made by clicking on the App button. Please make sure the required content is 
loading on the main URL https://<LBR-URL> i.e there should not be a sub-directory like https://<LBR-URL>/web_app etc.

Note:

You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are 
running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case,
please make sure to refresh the UI page.

For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task is
marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.



1. Add Jenkins Node: “Storage Server”

Go to Jenkins → Manage Jenkins → Manage Nodes → New Node

Fill in the required details:

| Field                 | Value                                                       |
| --------------------- | ----------------------------------------------------------- |
| Node Name             | Storage Server                                         |
| Type                  | Permanent Agent                                             |
| Remote root directory | /var/www/html                                           |
| Labels                | ststor01                                                |
| Launch Method         | SSH                                                         |
| Host                  | ststor01.stratos.xfusioncorp.com *(or the IP shown in lab)* |
| Credentials           | Create → SSH Username & Password (user is likely `natasha`) |

Very important

✔ The remote root directory MUST be exactly:
Ensure you install java 17 in the storage server
/var/www/html

Use git to clone the web_app in the html

Permissions Fix on Storage Server

If Jenkins cannot write to `/var/www/html`, run:

sudo chown -R natasha:natasha /var/www/html/web_app
sudo chmod -R 755 /var/www/html/web_app


2. Verify the Repository Exists

Storage Server already has:

/var/www/html/web_app

This is the Gitea clone.


3. Create the Pipeline Job

### Jenkins → New Item → Pipeline

Name: xfusion-webapp-job

Scroll to Pipeline section → Select Pipeline script.
working script:


Correct Jenkinsfile / Pipeline Script

groovy
pipeline {
    agent { label 'ststor01' }

    stages {
        stage('Deploy') {
            steps {
                sh '''
                    echo "Updating code from Gitea repository..."

                    # Go to the cloned repo
                    cd /var/www/html/web_app

                    # Fix Git safe directory issue
                    git config --global --add safe.directory /var/www/html/web_app

                    # Pull latest code
                    git pull

                    # Deploy: copy everything to /var/www/html
                    cp -r /var/www/html/web_app/* /var/www/html/
                '''
            }
        }
    }
}


4. Run the Job

Click Build Now

Expected output:

The job runs **on Storage Server**
/var/www/html/web_app` pulls latest changes from Gitea
Files copy to `/var/www/html` 
App servers serve the content via shared mount
LB shows new site at:

https://<LBR-URL>/
(Without `/web_app` in the path.)

You will pass the task if

✔ Storage Server node exists
✔ Remote root directory = `/var/www/html`
✔ Label = `ststor01`
✔ Pipeline job name = `xfusion-webapp-job`
✔ Stage name = `Deploy` (case-sensitive)
✔ Files appear in `/var/www/html` directly
✔ LB URL shows correct site


