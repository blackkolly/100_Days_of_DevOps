Sarah and Max were working on writting some stories which they have pushed to the repository. 
Max has recently added some new changes and is trying to push them to the repository but he is facing some issues.
Below you can find more details:

SSH into storage server using user max and password Max_pass123. 
Under /home/max you will find the story-blog repository. 
Try to push the changes to the origin repo and fix the issues. 
The story-index.txt must have titles for all 4 stories. Additionally,
there is a typo in The Lion and the Mooose line where Mooose should be Mouse.

Click on the Gitea UI button on the top bar. You should be able to access the Gitea page. 
You can login to Gitea server from UI using username sarah and password Sarah_pass123 or username max and password Max_pass123.
Note: For these kind of scenarios requiring changes to be done in a web UI, please take screenshots so that you can share it with us 
for review in case your task is marked incomplete. You may also consider using a screen recording software such as loom.com to record and share your work.

Step 1: SSH as Max
ssh -o StrictHostKeyChecking=no thor@jump_host
ssh max@ststor01    # password: Max_pass123

🔹 Step 2: Go to the repo
cd /home/max/story-blog

🔹 Step 3: Try to push
git push origin master


👉 If you see an error like “rejected, fetch first”, it means Sarah pushed something to origin that Max doesn’t have locally.

🔹 Step 4: Sync with remote
git fetch origin
git pull origin master


👉 If there are merge conflicts, fix them (likely in story-index.txt).

🔹 Step 5: Fix file contents

Open story-index.txt:

vi story-index.txt


Make sure it contains titles of all 4 stories.
Example:

The Fox and the Grapes
The Tortoise and the Hare
The Lion and the Mouse   <-- fix typo here
The Ant and the Grasshopper

 Fix Mooose → Mouse.

🔹 Step 6: Stage and commit
git add story-index.txt
git commit -m "Fix story-index titles and correct typo in The Lion and the Mouse"

🔹 Step 7: Push again
git push origin master


Now Max’s changes should go through.

🔹 Step 8: Verify in Gitea

Open the Gitea UI from the top bar.

Login as max (Max_pass123) or sarah (Sarah_pass123).

Go to the story-blog repository.

Check story-index.txt on the master branch → it should have 4 correct titles.
