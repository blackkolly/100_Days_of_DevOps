The Nautilus development team has provided requirements to the DevOps team for a new application development project,
specifically requesting the establishment of a Git repository. Follow the instructions below to create the Git repository on the Storage server
in the Stratos DC:

Utilize yum to install the git package on the Storage Server.

Create a bare repository named /opt/official.git (ensure exact name usage).

Step 1: SSH to Storage Server

From the jump host:
ssh -o StrictHostKeyChecking=no thor@jump_host
ssh natasha@ststor01    # password: Bl@kW
Step 2: Install Git

On ststor01

sudo yum install -y git
Verify:
git --version
 Step 3: Create Bare Repository

A bare repo is meant for sharing (no working directory).
sudo mkdir -p /opt/official.git
sudo git init --bare /opt/official.git

Step 4: Confirm
ls -ld /opt/official.git
ls /opt/official.git

You should see a directory structure like `branches`, `hooks`, `objects`, `refs`, etc.



👉 Do you also want me to show you how to set permissions (so multiple users can push/pull safely), or is this strictly a single-user repo f
