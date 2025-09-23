The Nautilus application development team has been working on a project repository /opt/official.git. 
This repo is cloned at /usr/src/kodekloudrepos on storage server in Stratos DC. They recently shared the following requirements with the DevOps team:
There are two branches in this repository, master and feature. One of the developers is working on the feature branch and their work is still 
in progress, however they want to merge one of the commits from the feature branch to the master branch, the message for the commit that needs 
to be merged into master is Update info.txt. Accomplish this task for them, also remember to push your changes eventually.


Step 1: Switch to `feature` and find the commit

git checkout feature
git log --oneline --grep="Update info.txt"
a1b2c3d Update info.txt

Step 2: Switch back to master

git checkout master

 Step 3: Cherry-pick the commit

git cherry-pick a1b2c3d


(replace `a1b2c3d` with the real hash from Step 1)

If no conflicts appear, the commit will be applied to `master`.


 Step 4: Push to origin

git push origin master

Step 5: Verify

git log --oneline -3

Now you should see something like
xxxxxxx Update info.txt
20daffa Add welcome.txt
16dc080 initial commit
