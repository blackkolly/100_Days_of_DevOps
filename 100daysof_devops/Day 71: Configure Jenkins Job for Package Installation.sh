Some new requirements have come up to install and configure some packages on the Nautilus infrastructure under Stratos Datacenter. The Nautilus DevOps 
team installed and configured a new Jenkins server so they wanted to create a Jenkins job to automate this task. Find below more details and complete the 
task accordingly:


1. Access the Jenkins UI by clicking on the Jenkins button in the top bar. Log in using the credentials: username admin and password Adm!n321.

2. Create a new Jenkins job named install-packages and configure it with the following specifications:

Add a string parameter named PACKAGE.
Configure the job to install a package specified in the $PACKAGE parameter on the storage server within the Stratos Datacenter.

Note:

1. Ensure to install any required plugins and restart the Jenkins service if necessary. Opt for Restart Jenkins when installation is complete and no 
jobs are running on the plugin installation/update page. Refresh the UI page if needed after restarting the service.

2. Verify that the Jenkins job runs successfully on repeated executions to ensure reliability.

3. Capture screenshots of your configuration for documentation and review purposes. Alternatively, use screen recording software like loom.com for 
comprehensive documentation and sharing.

Step 1: Access Jenkins UI

Click on the Jenkins button in the top bar to open the Jenkins dashboard.

Login with Username: admin and Password: Adm!n321.

Step 2: Create a New Job

Click “New Item”.

Enter Job name: install-packages.

Select “Freestyle project” and click OK.

Step 3: Configure Job Parameters

Scroll down to “This project is parameterized” and check the box.

Click “Add Parameter” → String Parameter.

Name: PACKAGE

Default Value: (optional, e.g., vim)

Description: Package name to install on remote server.

Step 4: Configure Build Step

Scroll to “Build” section → “Add build step” → “Send files or execute commands over SSH” (requires SSH plugin).

Configure the SSH Site (should already exist, e.g., storage):

Hostname: ststor01.stratos.xfusioncorp.com

Username: natasha

Password or Key: Bl@kW or SSH private key

In Exec command, enter:




