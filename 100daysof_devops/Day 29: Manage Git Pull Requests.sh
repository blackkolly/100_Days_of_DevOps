Max want to push some new changes to one of the repositories but we don't want people to push directly to master branch, since 
that would be the final version of the code. It should always only have content that has been reviewed and approved.
We cannot just allow everyone to directly push to the master branch. So, let's do it the right way as discussed below:


SSH into storage server using user max, password Max_pass123 . There you can find an already cloned repo under Max user's home.

Max has written his story about The 🦊 Fox and Grapes 🍇

Max has already pushed his story to remote git repository hosted on Gitea branch story/fox-and-grapes

Check the contents of the cloned repository. Confirm that you can see Sarah's story and history of commits by running git log and 
validate author info, commit message etc.

Max has pushed his story, but his story is still not in the master branch. Let's create a Pull Request(PR) to merge Max's story/fox-and-grapes 
branch into the master branch

Click on the Gitea UI button on the top bar. You should be able to access the Gitea page.


UI login info:

- Username: max

- Password: Max_pass123

PR title : Added fox-and-grapes story


PR pull from branch: story/fox-and-grapes (source)

PR merge into branch: master (destination)


Before we can add our story to the master branch, it has to be reviewed. So, let's ask tom to review our PR by assigning him as a reviewer


Add tom as reviewer through the Git Portal UI

Go to the newly created PR

Click on Reviewers on the right

Add tom as a reviewer to the PR

Now let's review and approve the PR as user Tom


Login to the portal with the user tom


Logout of Git Portal UI if logged in as max


UI login info:

- Username: tom

- Password: Tom_pass123

PR title : Added fox-and-grapes story

Review and merge it.

Great stuff!! The story has been merged! 👏


Note: For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us for review 
in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.


Step 1: SSH into Storage Server as Max

From jump host:
ssh -o StrictHostKeyChecking=no thor@jump_host
ssh max@ststor01    # password: Max_pass123

Step 2: Check repository content and logs
The repo is already cloned in Max’s home directory (/home/max), so:
cd ~/<repo_name>   # replace <repo_name> with the actual repo folder
ls -l
git log --oneline --decorate --graph
git log --author="Max"
👉 You should see Sarah’s commits as well as Max’s commit (story/fox-and-grapes) with his author info and commit message.

Step 3: Open Gitea UI
•	Click the Gitea UI button on the top bar (in your lab environment).
•	Login with:
o	Username: max
o	Password: Max_pass123

 Step 4: Create Pull Request
 
1.	Navigate to the repository in Gitea.
2.	Click Pull Requests → New Pull Request.
3.	Select:
o	Source branch: story/fox-and-grapes
o	Target branch: master
4.	Title: Added fox-and-grapes story
5.	Click Create Pull Request.

Step 5: Assign Reviewer (Tom)
1.	Open the newly created PR.
2.	On the right side, click Reviewers.
3.	Add tom as a reviewer.

 Step 6: Logout & Login as Tom
•	Logout from Gitea.
•	Login with:
o	Username: tom
o	Password: Tom_pass123

Step 7: Review & Merge PR
1.	Go to the Pull Request titled Added fox-and-grapes story.
2.	Review the changes → Approve.
3.	Click Merge Pull Request.






