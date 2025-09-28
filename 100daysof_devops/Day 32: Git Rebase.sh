The Nautilus application development team has been working on a project repository /opt/games.git. This repo is cloned at /usr/src/kodekloudrepos 
on storage server in Stratos DC. They recently shared the following requirements with DevOps team:

One of the developers is working on feature branch and their work is still in progress, 
however there are some changes which have been pushed into the master branch, the developer now wants to rebase the feature branch with the master 
branch without loosing any data from the feature branch, also they don't want to add any merge commit by simply merging the master branch 
into the feature branch. Accomplish this task as per requirements mentioned.
Also remember to push your changes once done.



Step 1: SSH to storage server


ssh natasha@ststor01    # password: Bl@kW


Step 2: Go to the cloned repo

cd /usr/src/kodekloudrepos/games

If Git complains about ownership:


git config --global --add safe.directory /usr/src/kodekloudrepos/games

Step 3: Fetch latest changes

git fetch origin

Step 4: Checkout feature branch

git checkout feature


Step 5: Rebase feature branch with master

git rebase origin/master

If there are no conflicts, it will complete immediately.
If there are conflicts, Git will stop and show them. Resolve conflicts in files, then:

  git add <file>
  git rebase --continue
  
If you need to abort:

  git rebase --abort

Step 6: Push the rebased brance
Since rebase rewrites commit history, you need to force push:
git push origin feature --force

Step 7: Verify
git log --oneline --graph --decorate --all

