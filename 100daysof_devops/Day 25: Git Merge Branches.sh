The Nautilus application development team has been working on a project repository /opt/ecommerce.git. This repo is cloned at /usr/src/kodekloudrepos on storage server in Stratos DC. They recently shared the following requirements with
DevOps team:
Create a new branch devops in /usr/src/kodekloudrepos/ecommerce repo from master and copy the /tmp/index.html file (present on storage server itself) into the repo.
Further, add/commit this file in the new branch and merge back that branch into master branch. Finally, push the changes to the origin for both of the branches.


Step 1: SSH into Storage Server

From jump host:

ssh natasha@ststor01    # password: Bl@kW


Step 2: Go to the cloned repo


cd /usr/src/kodekloudrepos/ecommerce

If Git complains about “dubious ownership” (like earlier), mark it safe:


git config --global --add safe.directory /usr/src/kodekloudrepos/ecommerce
Step 3: Create and switch to `devops` branch

git checkout master
git pull origin master   # sync with remote just in case
git checkout -b devops


Step 4: Copy the file into repo

cp /tmp/index.html /usr/src/kodekloudrepos/ecommerce

Check:

ls -l index.html

 Step 5: Stage and commit

git add index.html
git commit -m "Add index.html from /tmp into devops branch"

Step 6: Merge into master

Switch back and merge:

git checkout master
git merge devops -m "Merge devops branch into master"

Step 7: Push both branches to origin

git push origin master
git push origin devops

Step 8: Verify
git log --oneline --graph --decorate --all | head -n 10

