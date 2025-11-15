The development team of xFusionCorp Industries is working on to develop a new static website and they are planning to deploy the same on Nautilus App Servers using Jenkins pipeline. They have shared their requirements with the DevOps team and accordingly
we need to create a Jenkins pipeline job. Please find below more details about the task:

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.

Similarly, click on the Gitea button on the top bar to access the Gitea UI. Login using username sarah and password Sarah_pass123. There under user sarah you
will find a repository named web_app that is already cloned on Storage server under /var/www/html. sarah is a developer who is working on this repository.

Add a slave node named Storage Server. It should be labeled as ststor01 and its remote root directory should be /var/www/html.

We have already cloned repository on Storage Server under /var/www/html.

Apache is already installed on all app Servers its running on port 8080.

Create a Jenkins pipeline job named devops-webapp-job (it must not be a Multibranch pipeline) and configure it to:

Add a string parameter named BRANCH.

It should conditionally deploy the code from web_app repository under /var/www/html on Storage Server, as this location is already mounted to the document
root /var/www/html of app servers. The pipeline should have a single stage named Deploy ( which is case sensitive ) to accomplish the deployment.

The pipeline should be conditional, if the value master is passed to the BRANCH parameter then it must deploy the master branch, on the other hand if the 
value feature is passed to the BRANCH parameter then it must deploy the feature branch.

LB server is already configured. You should be able to see the latest changes you made by clicking on the App button. Please make sure the required content is 
loading on the main URL https://<LBR-URL> i.e there should not be a sub-directory like https://<LBR-URL>/web_app etc.

Note:
You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs 
are running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, 
please make sure to refresh the UI page.

For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your 
task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.



1. Add Slave Node: Storage Server
Jenkins → Manage Jenkins → Manage Nodes → New Node
| Field                 | Value                                    |
| --------------------- | ---------------------------------------- |
| Node Name             | Storage Server                           |
| Type                  | Permanent Agent                          |
| Remote Root Directory | `/var/www/html`                          |
| Labels                | `ststor01`                               |
| Launch Method         | SSH                                      |
| Host                  | `ststor01.stratos.xfusioncorp.com`       |
| Credentials           | natasha / Bl@kW (or correct credentials) |

> Important: The **Remote Root Directory MUST be exactly `/var/www/html`.
> If permissions errors occur, run on Storage Server:

sudo chown -R natasha:natasha /var/www/html
sudo chmod -R 755 /var/www/html

2. Create Pipeline Job

New Item → devops-webapp-job → Pipeline → OK

Scroll to Pipeline section.

Definition: Pipeline script
Parameters: Add a String Parameter

| Name   | Default Value | Description                              |
| ------ | ------------- | ---------------------------------------- |
| BRANCH | master        | Branch to deploy (`master` or `feature`) |


3. Pipeline Script (Parameterized Conditional Deployment)
pipeline {
    agent { label 'ststor01' }

    parameters {
        string(name: 'BRANCH', defaultValue: 'master', description: 'Branch to deploy: master or feature')
    }

    stages {
        stage('Deploy') {
            steps {
                script {
                    echo "Deploying branch: ${params.BRANCH}"

                    // Go to cloned repository
                    sh '''
                        cd /var/www/html/web_app
                        git config --global --add safe.directory /var/www/html/web_app
                        git fetch --all
                    '''

                    if (params.BRANCH == 'master') {
                        sh '''
                            cd /var/www/html/web_app
                            git checkout master
                            git pull origin master
                        '''
                    } else if (params.BRANCH == 'feature') {
                        sh '''
                            cd /var/www/html/web_app
                            git checkout feature
                            git pull origin feature
                        '''
                    } else {
                        error "Unknown branch: ${params.BRANCH}"
                    }

                    // Copy to document root
                    sh '''
                        cp -r /var/www/html/web_app/* /var/www/html/
                        echo "Deployment of ${BRANCH} branch completed."
                    
                }
            }
        }
    }
}




 4. Run the Pipeline

1. Click Build with Parameters → enter `BRANCH=master` or `BRANCH=feature`
2. Check Console Output:

Deploying branch: master
Deployment of master branch completed.

3. Open LB URL → site should load at:

https://<LBR-URL>/


(no `/web_app` in the path).



If you want, I can provide a **ready-to-copy Groovy script** that **handles any future branch names dynamically** without editing the pipeline. This avoids errors if another branch is added later. Do you want me to do that?
