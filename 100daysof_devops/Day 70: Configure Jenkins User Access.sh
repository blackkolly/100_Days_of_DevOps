The Nautilus team is integrating Jenkins into their CI/CD pipelines. After setting up a new Jenkins server, they're now configuring user access for the development team, Follow these steps:



1. Click on the Jenkins button on the top bar to access the Jenkins UI. Login with username admin and password Adm!n321.

2. Create a jenkins user named javed with the passwordB4zNgHA7Ya. Their full name should match Javed.

3. Utilize the Project-based Matrix Authorization Strategy to assign overall read permission to the javed user.

4. Remove all permissions for Anonymous users (if any) ensuring that the admin user retains overall Administer permissions.

5. For the existing job, grant javed user only read permissions, disregarding other permissions such as Agent, SCM etc.


Note:

1. You may need to install plugins and restart Jenkins service. After plugins installation, select Restart Jenkins when installation is complete and no jobs are running on plugin installation/update page.


2. After restarting the Jenkins service, wait for the Jenkins login page to reappear before proceeding. Avoid clicking Finish immediately after restarting the service.


3. Capture screenshots of your configuration for review purposes. Consider using screen recording software like loom.com for documentation and sharing.

Step 1: Log into Jenkins

1. Click the Jenkins button on the top bar.
2. Log in with:

   Username: admin
   Password: Adm!n321

 Step 2: Create the new user “javed”

1. Go to **Manage Jenkins → Security → Manage Users
2. Click Create User
3. Fill out the form:

   
   Username: javed
   Password: B4zNgHA7Ya
   Full name: Javed
   Email: (optional)
   
4. Click Create User

Step 3: Enable Matrix-based Security

1. Go to Manage Jenkins → Security → Configure Global Security
2. Under Authorization, select Project-based Matrix Authorization Strategy
   (If it’s missing, install the plugin Matrix Authorization Strategy Plugin via:

   Manage Jenkins → Manage Plugins → Available → Search “Matrix Authorization” → Install and restart)

 Step 4: Configure global permissions

Once “Project-based Matrix Authorization” is active:

1. Add both users to the matrix:

   * Click Add user or group
   * Add:

     admin
     javed
     (optional: Anonymous — if it exists, remove or uncheck)
    

2. Grant permissions:

   * ✅ For `admin`: check Overall → Administer 
   * ✅ For `javed`: check only Overall → Read
   * 🚫 For `Anonymous`: uncheck everything (or remove if possible)

3. Click Save


Step 5: Configure job-level permissions

Since you are using *Project-based Matrix Authorization Strategy*:

1. Go to your existing Jenkins job.
2. Click Configure → scroll to **Build Authorization**
3. Check Enable project-based security
4. In the permission matrix:

   * Add user `javed`
   * Grant only:

     
     Job → Read
     
   * Do not check Build, Configure, Delete, or anything else.
5. Save changes.


Step 6: Verify access

1. Log out as `admin`
2. Log in as `javed` (Username: javed / Password: B4zNgHA7Ya)
3. Confirm:

   * You can see the job but cannot edit or build.
   * You can view Jenkins dashboard (read-only).



