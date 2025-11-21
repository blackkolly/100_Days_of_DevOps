The Nautilus DevOps team needs to copy data from the jump host to all application servers in Stratos DC using Ansible. Execute the task with the following details:
a. Create an inventory file /home/thor/ansible/inventory on jump_host and add all application servers as managed nodes.
b. Create a playbook /home/thor/ansible/playbook.yml on the jump host to copy the /usr/src/dba/index.html file to all application servers, placing it at /opt/dba.
Note: Validation will run the playbook using the command ansible-playbook -i inventory playbook.yml. Ensure the playbook functions properly without any extra arguments.

Solution: Copy Data to All Application Servers Using Ansible

Step 1: Create the Ansible Directory

Create directory if it doesn't exist
mkdir -p /home/thor/ansible
cd /home/thor/ansible

Step 2: Create the Inventory File
Create the inventory with all three application servers:

cat > /home/thor/ansible/inventory << 'EOF'
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_password=Ir0nM@n ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=Am3ric@ ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=BigGr33n ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF


Alternative: Inventory with Groups (Better organized)

cat > /home/thor/ansible/inventory << 'EOF'
[app_servers]
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_password=Ir0nM@n
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=Am3ric@
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=BigGr33n

[app_servers:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Step 3: Create the Playbook
Create the playbook to copy the file to all application servers:

cat > /home/thor/ansible/playbook.yml << 'EOF'
- name: Copy index.html to all application servers
  hosts: all
  become: yes
  tasks:
    - name: Ensure destination directory exists
      file:
        path: /opt/dba
        state: directory
        mode: '0755'
    
    - name: Copy index.html to application servers
      copy:
        src: /usr/src/dba/index.html
        dest: /opt/dba/index.html
        mode: '0644'
EOF

Step 4: Verify the Files
Check inventory file
cat /home/thor/ansible/inventory

Check playbook
cat /home/thor/ansible/playbook.yml

# Verify source file exists
ls -la /usr/src/dba/index.html

Step 5: Test Inventory Connectivity

Test connectivity to all application servers:
cd /home/thor/ansible

Ping all servers
ansible -i inventory all -m ping

Expected output:
stapp01 | SUCCESS => {
  "changed": false,
    "ping": "pong"
}
 stapp02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
stapp03 | SUCCESS => {
   "changed": false,
   "ping": "pong"
}


Step 6: Run the Playbook

Execute the playbook:

ansible-playbook -i inventory playbook.yml


Expected output:

PLAY [Copy index.html to all application servers] ******************************

TASK [Gathering Facts] **********************************************************
ok: [stapp01]
ok: [stapp02]
ok: [stapp03]

TASK [Ensure destination directory exists] *************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [Copy index.html to application servers] **********************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

PLAY RECAP **********************************************************************
stapp01                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
stapp02                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
stapp03                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


step 7: Verify the File was Copied

Verify the file exists on all application servers:

Using Ansible
ansible -i inventory all -m command -a "ls -la /opt/dba/index.html"

Or check content
ansible -i inventory all -m command -a "cat /opt/dba/index.html"

