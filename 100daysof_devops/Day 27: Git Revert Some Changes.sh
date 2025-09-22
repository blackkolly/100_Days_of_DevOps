The Nautilus application development team was working on a git repository /usr/src/kodekloudrepos/apps present on Storage server in Stratos DC. However, 
they reported an issue with the recent commits being pushed to this repo. They have asked the DevOps team to revert repo HEAD to last commit. 
Below are more details about the task:

In /usr/src/kodekloudrepos/blog git repository, revert the latest commit ( HEAD ) to the previous commit (JFYI the previous commit hash should be
with initial commit message ).
Use revert apps message (please use all small letters for commit message) for the new revert commit.


Step 1: SSH into Storage Server

ssh natasha@ststor01    # password: Bl@kW

Step 2: Go to the repo

cd /usr/src/kodekloudrepos/blog

If Git warns about ownership:

git config --global --add safe.directory /usr/src/kodekloudrepos/blog

Step 3: Verify history

git log --oneline -2

You should see:
<hash1> <latest commit message>   <-- HEAD
<hash2> initial commit message

Step 4: Revert the latest commit

Run:
git revert HEAD --no-edit


git commit --amend -m "revert blog"
Step 5: Verify

git log --oneline -2

You should see:
<newhash> revert blog
<hash2>   initial commit message

