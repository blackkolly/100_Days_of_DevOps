The Nautilus DevOps team has installed and configured new Jenkins server in Stratos DC which they will use for CI/CD and for some automation tasks.
There is a requirement to add all app servers as slave nodes in Jenkins so that they can perform tasks on these servers using Jenkins. Find below more details and accomplish the task accordingly.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.
1. Add all app servers as SSH build agent/slave nodes in Jenkins. Slave node name for app server 1, app server 2 and app server 3 must 
be App_server_1, App_server_2, App_server_3 respectively.

2. Add labels as below:
App_server_1 : stapp01
App_server_2 : stapp02
App_server_3 : stapp03

3. Remote root directory for App_server_1 must be /home/tony/jenkins, for App_server_2 must be /home/steve/jenkins and for App_server_3 must be /home/banner/jenkins.
4. Make sure slave nodes are online and working properly.

Note:
1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are 
running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case,
please make sure to refresh the UI page.

2. For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task 
is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.


Step-by-Step Configuration

1. Login to Jenkins

* Access Jenkins:
  `http://jenkins.stratos.xfusioncorp.com:8080`
* Login as:
  Username: `admin`
  Password:`Adm!n321`


2. Install Required Plugins (if not installed)

You need the SSH Build Agents Plugin.

Go to:

* Manage Jenkins → Plugins → Available Plugins
* Search for: SSH Build Agents Plugin
* Install and restart Jenkins
* If Jenkins gets stuck, refresh after a few minutes (normal during plugin restarts)


3. Add SSH Credentials for Each App Server
Navigate:
`Manage Jenkins → Credentials → (global) → Add Credentials`

For each app server, add:

| Type                       | Username | Password | ID (optional) | Description  |
| -------------------------- | -------- | -------- | ------------- | ------------ |
| SSH Username with Password | tony     | Ir0nM@n  | stapp01_creds | App Server 1 |
| SSH Username with Password | steve    | Am3ric@  | stapp02_creds | App Server 2 |
| SSH Username with Password | banner   | BigGr33n | stapp03_creds | App Server 3 |


4. Add Jenkins Nodes (One by One)**

App_server_1

Go to:
Manage Jenkins → Nodes → New Node

* Node name: `App_server_1`
* Select **Permanent Agent**
* Click OK

Then fill in:

* Description: `App Server 1 Node`
* Remote root directory: `/home/tony/jenkins`
* Labels: `stapp01`
* Launch method: Launch agents via SSH

  * Host: `stapp01.stratos.xfusioncorp.com`
  * Credentials: select the one for `tony`
* Leave defaults for:

  * Host Key Verification: Non verifying Verification Strategy**
* Click Save and Launch

✅ If successful, it will show Agent is connected.


App_server_2

Same steps as above, but:

* Node name: `App_server_2`
* Remote root directory: `/home/steve/jenkins`
* Label: `stapp02`
* Host: `stapp02.stratos.xfusioncorp.com`
* Credentials: `steve / Am3ric@`

App_server_3

Same pattern:

* Node name: `App_server_3`
* Remote root directory: `/home/banner/jenkins`
* Label: `stapp03`
* Host: `stapp03.stratos.xfusioncorp.com`
* Credentials: `banner / BigGr33n`



5. Verify Nodes Are Online

After saving each node, Jenkins will try to connect.
You should see a green check or Agent is connected message.

If it shows offline, check:

# From Jenkins server
ssh tony@172.16.238.10

If SSH works manually, check if the `/home/<user>/jenkins` directory exists:


mkdir -p /home/tony/jenkins
chown tony:tony /home/tony/jenkins
and install java ....Make sure the java version on jenkinson master and Node are the same
sudo yum install -y java-17-openjdk java-17-openjdk-devel


Repeat for `steve` and `banner`.

Then retry connection from Jenkins.

The nodes are online now

