The Nautilus application development team was working on a git repository /usr/src/kodekloudrepos/news present on Storage server in Stratos DC. 
One of the developers stashed some in-progress changes in this repository, but now they want to restore some of the stashed changes.
Find below more details to accomplish this task:

Look for the stashed changes under /usr/src/kodekloudrepos/news git repository, and restore the stash with stash@{1} identifier. 
Further, commit and push your changes to the origin.


Step 1: SSH into Storage server
ssh natasha@ststor01   # password: Bl@kW

Step 2: Go to the repo

cd /usr/src/kodekloudrepos/news

If Git complains about ownership:

git config --global --add safe.directory /usr/src/kodekloudrepos/news

Step 3: Check stashes
git stash list
You should see something like:

stash@{0}: WIP on master: abc123 some message
stash@{1}: WIP on master: def456 in-progress changes


Step 4: Apply the correct stash

git stash apply stash@{1}

Step 5: Stage and commit the restored changes

git add .
git commit -m "restore stash changes from stash@{1}"

Step 6: Push to origin


git push origin master

Step 7: Verify
git log --oneline -1

You should see your commit:
xxxxxxx restore stash changes from stash@{1}
