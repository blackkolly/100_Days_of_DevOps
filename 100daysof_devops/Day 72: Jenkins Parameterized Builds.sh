A new DevOps Engineer has joined the team and he will be assigned some Jenkins related tasks. Before that, the team wanted to test a simple parameterized job to understand basic functionality of parameterized builds. He is given a simple parameterized job to build in Jenkins. Please find more details below:



Click on the Jenkins button on the top bar to access the Jenkins UI. Login using username admin and password Adm!n321.


1. Create a parameterized job which should be named as parameterized-job


2. Add a string parameter named Stage; its default value should be Build.


3. Add a choice parameter named env; its choices should be Development, Staging and Production.


4. Configure job to execute a shell command, which should echo both parameter values (you are passing in the job).


5. Build the Jenkins job at least once with choice parameter value Staging to make sure it passes.

Note:
1. You might need to install some plugins and restart Jenkins service. So, we recommend clicking on Restart Jenkins when installation is complete
and no jobs are running on plugin installation/update page i.e update centre. Also, Jenkins UI sometimes gets stuck when Jenkins service restarts in the back end. 
In this case, please make sure to refresh the UI page.

2. For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review 
in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.





Step 1: Access Jenkins UI

1. Click the enkins button on the top navigation bar (in your lab environment).
2. Login using:

   * Username: `admin`
   * Password: `Adm!n321`

Step 2: Create a New Jenkins Job

1. On the Jenkins dashboard, click New Item .
2. Enter the name: `parameterized-job`.
3. Select Freestyle project.
4. Click OK to proceed.


Step 3: Add Job Parameters

1. On the job configuration page, check This project is parameterized.
2. Click Add Paramete → String Parameter:

   Name:`Stage`
   Default Value: `Build`
   (Optional) Description: Enter the current stage name
3. Click Add Parameter→ Choice Parameter:

   Name: `env`
   Choices:
   
     Development
     Staging
     Production
    
   (Optional) Description: Select environment name

Step 4: Configure the Build Step

1. Scroll to the Build section.
2. Click Add build step → Execute shell
3. In the command box, enter:


echo "Stage parameter value: $Stage"
echo "Environment parameter value: $env"
```

---

### 💾 **Step 5: Save the Job**

Click **Save** at the bottom of the page.

---

### ▶️ **Step 6: Build the Job**

1. Click **“Build with Parameters”** on the left menu.
2. Enter / confirm parameters:

   * **Stage:** Build (default)
   * **env:** Staging
3. Click **Build**.

---

### 🔍 **Step 7: Verify Output**

1. Click on the **Build Number (#1)** under **Build History**.
2. Click **Console Output**.
3. You should see output like this:

```
Started by user admin
Building in workspace /var/lib/jenkins/workspace/parameterized-job
Stage parameter value: Build
Environment parameter value: Staging
Finished: SUCCESS
```

✅ This confirms that:

* The parameters are working.
* Jenkins correctly echoed both values.
* The job ran successfully.

---

### ⚠️ **Troubleshooting / Notes**

* If you’re missing the “Build with Parameters” option, ensure “This project is parameterized” is checked.
* If Jenkins asks to install plugins (e.g., for shell execution), install and then **Restart Jenkins**.
* After restarting, refresh your browser before retrying.

---

Would you like me to give you a **ready-to-copy Jenkinsfile** version of this job (for Pipeline use instead of Freestyle)? It’s often useful for automation and reuse.
