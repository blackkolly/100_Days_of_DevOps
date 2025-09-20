The DevOps team established a new Git repository last week, which remains unused at present. However, the Nautilus application development team now 
requires a copy of this repository on the Storage Server in the Stratos DC. Follow the provided details to clone the repository:
The repository to be cloned is located at /opt/media.git
Clone this Git repository to the /usr/src/kodekloudrepos directory. Perform this task using the natasha user, and ensure that no modifications 
are made to the repository or existing directories, such as changing permissions or making unauthorized alterations.

Perfect 👍 — the task is to **clone an existing bare Git repo** (`/opt/media.git`) into a new directory on the **Storage Server (ststor01)**, without altering any other directories or permissions.

Here’s how you can do it cleanly:

Step 1: SSH to Storage Server

From jump host:
ssh -o StrictHostKeyChecking=no thor@jump_host
ssh natasha@ststor01

Step 2: Clone the Repository
mkdir -p /usr/src/kodekloudrepos
cd /usr/src/kodekloudrepos
git clone /opt/media.git

This will create a new repo directory `/usr/src/kodekloudrepos/media`.
Step 3: Verify
ls -l /usr/src/kodekloudrepos/
ls -l /usr/src/kodekloudrepos/media


