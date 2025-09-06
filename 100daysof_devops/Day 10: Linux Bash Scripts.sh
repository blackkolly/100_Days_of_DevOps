Steps we’ll take

Install prerequisites (outside script)
On App Server 1 (as tony user), install zip:

sudo yum install -y zip   # (RHEL/CentOS)
# or
sudo apt-get install -y zip  # (Ubuntu/Debian)


Setup passwordless SSH
From tony@app1 → backup server (e.g. clint@stbkp01)
Generate key and copy:

ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa
ssh-copy-id clint@stbkp01   # adjust user/host as per environment


This ensures scp won’t ask for a password.

Create the script
Path: /scripts/blog_backup.sh

The production support team of xFusionCorp Industries is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for taking websites backup. They have a static website running on App Server 1 in Stratos Datacenter, and they need to create a bash script named blog_backup.sh which should accomplish the following tasks. (Also remember to place the script under /scripts directory on App Server 1).

a. Create a zip archive named xfusioncorp_blog.zip of /var/www/html/blog directory.
b. Save the archive in /backup/ on App Server 1. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on Nautilus Backup Server.
c. Copy the created archive to Nautilus Backup Server server in /backup/ location.
d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user (for example, tony in case of App Server 1) must be able to run it.
e. Do not use sudo inside the script.

Note:
The zip package must be installed on given App Server before executing the script. This package is essential for creating the zip archive of the website files. Install it manually outside the script.

#!/bin/bash

# Variables
SRC_DIR="/var/www/html/blog"
BACKUP_DIR="/backup"
ARCHIVE_NAME="xfusioncorp_blog.zip"
BACKUP_SERVER="stbkp01"       # Nautilus Backup Server hostname
BACKUP_USER="clint"           # User on Backup Server
REMOTE_DIR="/backup"

# Step a: Create zip archive
zip -r "${BACKUP_DIR}/${ARCHIVE_NAME}" "$SRC_DIR"

# Step c: Copy archive to Backup Server
scp "${BACKUP_DIR}/${ARCHIVE_NAME}" ${BACKUP_USER}@${BACKUP_SERVER}:${REMOTE_DIR}/


Permissions

mkdir -p /scripts
vi /scripts/blog_backup.sh     # paste script
chmod +x /scripts/blog_backup.sh


Run the script
As tony on App Server 1:
./scripts/blog_backup.sh

/scripts/blog_backup.sh
