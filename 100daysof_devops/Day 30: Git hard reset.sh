The Nautilus application development team was working on a git repository /usr/src/kodekloudrepos/media present on Storage server in Stratos DC. 
This was just a test repository and one of the developers just pushed a couple of changes for testing, but now they want to clean this repository
along with the commit history/work tree, so they want to point back the HEAD and the branch itself to a commit with message add data.txt file. 
Find below more details:

In /usr/src/kodekloudrepos/media git repository, reset the git commit history so that there are only two commits in the commit history i.e 
initial commit and add data.txt file.
Also make sure to push your changes.


Step 1: SSH into Storage Server



ssh natasha@ststor01   # password: Bl@kW


Step 2: Go to the repo


cd /usr/src/kodekloudrepos/media

If Git warns about ownership:

git config --global --add safe.directory /usr/src/kodekloudrepos/media




Step 3: Check commit history


git log --oneline --graph --decorate

Identify the commit hash of `add data.txt file`.
Let’s say it is `abc1234`.

Step 4: Reset branch to that commit


git checkout master
git reset --hard abc1234

Step 5: Clean up history (rebuild branch with only required commits)

We want only `initial commit` and `add data.txt file`.
So we rebase interactively from the beginning:

git rebase -i --root

An editor will open with all commits listed.

* Keep only the initial commit and add data.txt file.
* Delete all other commit lines.
* Save & exit.

Now the history will only have 2 commits.
Step 6: Force push the cleaned branch

git push origin master --force

Step 7: Verify
git log --oneline

👉 You should see exactly:

<hash2> add data.txt file
<hash1> initial commit
