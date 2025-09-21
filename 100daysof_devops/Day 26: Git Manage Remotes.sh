The xFusionCorp development team added updates to the project that is maintained under /opt/cluster.git repo and cloned under /usr/src/kodekloudrepos/cluster.
Recently some changes were made on Git server that is hosted on Storage server in Stratos DC. The DevOps team added some new Git remotes, 
so we need to update remote on /usr/src/kodekloudrepos/cluster repository as per details mentioned below:

a. In /usr/src/kodekloudrepos/cluster repo add a new remote dev_cluster and point it to /opt/xfusioncorp_cluster.git repository.
b. There is a file /tmp/index.html on same server; copy this file to the repo and add/commit to master branch.
c. Finally push master branch to this new remote origin.

Step 1: SSH to Storage Server

From jump host:

ssh natasha@ststor01    # password: Bl@kW


Step 2: Go to the cloned repo

cd /usr/src/kodekloudrepos/cluster

If Git complains about ownership (dubious ownership issue like before):
git config --global --add safe.directory /usr/src/kodekloudrepos/cluster

Step 3: Add new remote
git remote add dev_cluster /opt/xfusioncorp_cluster.git

Verify:
git remote -v
You should see `dev_cluster` pointing to `/opt/xfusioncorp_cluster.git`.

Step 4: Copy file into repo

cp /tmp/index.html .

Step 5: Stage and commit
git checkout master
git add index.html
git commit -m "Add index.html to master branch"

Step 6: Push to new remote

git push dev_cluster master

Step 7: Verify

List branches on new remote:
git ls-remote dev_cluster

