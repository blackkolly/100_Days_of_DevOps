Nautilus developers are actively working on one of the project repositories, /usr/src/kodekloudrepos/ecommerce. Recently, 
they decided to implement some new features in the application, and they want to maintain those new changes in a separate branch. Below are the 
requirements that have been shared with the DevOps team:

On Storage server in Stratos DC create a new branch xfusioncorp_ecommerce from master branch in /usr/src/kodekloudrepos/ecommerce git repo.
Please do not try to make any changes in the code.


Step 1: SSH to Storage Server
ssh natasha@ststor01   

Step 2: Go to the Repository
cd /usr/src/kodekloudrepos/ecommerce

git status
Step 3: Create New Branch

1. Ensure you’re on `master`:
git checkout master
2. Create the new branch:
git checkout -b xfusioncorp_ecommerce
🔹 Step 4: Verify
git branch

xfusioncorp_ecommerce
  master

