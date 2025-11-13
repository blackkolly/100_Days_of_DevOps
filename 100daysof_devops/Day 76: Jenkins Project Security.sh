The xFusionCorp Industries has recruited some new developers. There are already some existing jobs on Jenkins and two of these new developers need 
permissions to access those jobs. The development team has already shared those requirements with the DevOps team, so as per details mentioned below 
grant required permissions to the developers.

Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.
There is an existing Jenkins job named Packages, there are also two existing Jenkins users named sam with password sam@pass12345 and 
rohan with password rohan@pass12345.


Grant permissions to these users to access Packages job as per details mentioned below:


a.) Make sure to select Inherit permissions from parent ACL under inheritance strategy for granting permissions to these users.


b.) Grant mentioned permissions to sam user : build, configure and read.


c.) Grant mentioned permissions to rohan user : build, cancel, configure, read, update and tag.

Note:

Please do not modify/alter any other existing job configuration.

You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete and no jobs are
running on plugin installation/update page i.e update centre. Also Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. In this case, 
please make sure to refresh the UI page.


For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review in case your task 
is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.




* URL → `http://jenkins.stratos.xfusioncorp.com:8080`
* Username → `admin`
* Password → `Adm!n321`

Existing users:
sam / sam@pass12345`
`rohan / rohan@pass12345`

Existing job:
`Packages`



 Step-by-Step Configuration

Step 1 — Install/Enable “Project-based Matrix Authorization Strategy” Plugin

1. Go to:
   Manage Jenkins → Plugins → Available Plugins
2. Search for:

   Matrix Authorization Strategy
3. Install it (it might already be installed on many Jenkins instances).
4. After installation, click “Restart Jenkins when installation is complete”.
5. Refresh Jenkins UI after it comes back up.

Step 2 — Enable Project-based Security Globally

1. Go to:
   Manage Jenkins → Configure Global Security
2. Under Authorization, make sure either:

   * “Matrix-based security” or
   * “Project-based Matrix Authorization Strategy”
     is enabled.
3. (Do not remove existing users/permissions — leave them as-is.)
4. Scroll down and Save.


Step 3 — Open the “Packages” Job Configuration

1. From the Jenkins dashboard → click the job Packages.
2. On the left sidebar → click Configure.
3. Scroll down to the “Enable project-based security” section.

   Check Enable project-based security”
   Select Inherit permissions from parent ACL (as required).
4. You’ll now see a permissions matrix.

Step 4 — Add User `sam

Click Add user or group → sam

Then check the following boxes for `sam`:

* Job → Build
* Job → Configure
*Job → Read

---

tep 5 — Add User `rohan`

Click Add user or group → rohan

Then check:

* Job → Build
* Job → Cancel
* Job → Configure
* Job → Read
* job → Update
*Job → Tag



Step 6 — Save Configuration

Scroll to the bottom → click Save.


tep 7 — Verify Permissions

You can verify by logging in as each user:

Login as sam

* Username: `sam`
* Password: `sam@pass12345`
* Go to `Packages` job → You should be able to view, configure, and build, but not delete or modify permissions.

Login as rohan

* Username: `rohan`
* Password: `rohan@pass12345`
* Go to `Packages` job → Should be able to build, cancel builds, read, configure, update, and tag.
