An Ansible playbook needs completion on the jump host, where a team member left off. Below are the details:

The inventory file /home/thor/ansible/inventory requires adjustments. The playbook must run on App Server 2 in Stratos DC. Update the inventory accordingly.

Create a playbook /home/thor/ansible/playbook.yml. Include a task to create an empty file /tmp/file.txt on App Server 2.

Note: Validation will run the playbook using the command ansible-playbook -i inventory playbook.yml. Ensure the playbook

Solution: Complete Ansible Playbook for App Server 2


 Step 1: Update the Inventory File

Update the inventory file to target App Server 2 (stapp02):

Navigate to the ansible directory
cd /home/thor/ansible/

Create/Update the inventory file
cat > /home/thor/ansible/inventory << 'EOF'
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=Am3ric@ ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Verify the inventory file:
cat /home/thor/ansible/inventory

Expected output:
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=Am3ric@ ansible_ssh_common_args='-o StrictHostKeyChecking=no'


Step 2: Create the Playbook

Create the playbook to create an empty file on App Server 2:

cat > /home/thor/ansible/playbook.yml << 'EOF'
- name: Create empty file on App Server 2
  hosts: stapp02
  become: yes
  tasks:
    - name: Create empty file /tmp/file.txt
      file:
        path: /tmp/file.txt
        state: touch
        mode: '0644'
EOF
Verify the playbook:
cat /home/thor/ansible/playbook.yml


Step 3: Test the Inventory Connection

Test connectivity before running the playbook:
Test ping
ansible -i inventory stapp02 -m ping
Expected output:
stapp02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

Step 4: Run the Playbook
Execute the playbook:

ansible-playbook -i inventory playbook.yml

Expected output:
```
PLAY [Create empty file on App Server 2] ***************************************

TASK [Gathering Facts] **********************************************************
ok: [stapp02]

TASK [Create empty file /tmp/file.txt] ******************************************
changed: [stapp02]

PLAY RECAP **********************************************************************
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Step 5: Verify the File was Created

Verify the file exists on App Server 2:
Method 1: Using Ansible
ansible -i inventory stapp02 -m command -a "ls -la /tmp/file.txt"

Method 2: SSH manually
ssh steve@172.16.238.11
# Password: Am3ric@
ls -la /tmp/file.txt


