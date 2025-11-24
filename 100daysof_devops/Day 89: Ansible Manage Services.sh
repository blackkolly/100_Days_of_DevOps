Developers are looking for dependencies to be installed and run on Nautilus app servers in Stratos DC. They have shared some requirements with the DevOps team. 
Because we are now managing packages installation and services management using Ansible, some playbooks need to be created and tested. As per details mentioned below please complete the task:

a. On jump host create an Ansible playbook /home/thor/ansible/playbook.yml and configure it to install httpd on all app servers.

b. After installation make sure to start and enable httpd service on all app servers.

c. The inventory /home/thor/ansible/inventory is already there on jump host.

d. Make sure user thor should be able to run the playbook on jump host.

Note: Validation will try to run playbook using command ansible-playbook -i inventory playbook.yml so please make sure playbook works this way, without passing 
any extra arguments.



Step 1: Navigate to Ansible Directory

cd /home/thor/ansible

Step 2: Check the Existing Inventory

Check if inventory file exists and view its content
cat inventory

If the inventory file doesn't exist or needs updating, create/update it:

cat > /home/thor/ansible/inventory << 'EOF'
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Step 3: Create the Playbook

Create the playbook to install and configure httpd:

cat > /home/thor/ansible/playbook.yml << 'EOF'
---
- name: Install and configure httpd on all app servers
  hosts: all
  become: yes
  tasks:
    - name: Install httpd package
      yum:
        name: httpd
        state: present
    
    - name: Start and enable httpd service
      service:
        name: httpd
        state: started
        enabled: yes
EOF


Step 4: Verify the Files

Check inventory
cat /home/thor/ansible/inventory

Check playbook
cat /home/thor/ansible/playbook.yml

Verify file ownership (should be thor)
ls -la /home/thor/ansible/

Check playbook syntax
ansible-playbook -i inventory playbook.yml --syntax-check

Step 5: Test Ansible Connectivity

cd /home/thor/ansible
Test connection to all app servers
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

ansible-playbook -i inventory playbook.yml

Expected output:
PLAY [Install and configure httpd on all app servers] *******************************

TASK [Gathering Facts] ***************************************************************
ok: [stapp01]
ok: [stapp02]
ok: [stapp03]

TASK [Install httpd package] *********************************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [Start and enable httpd service] ************************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

PLAY RECAP ***************************************************************************
stapp01                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
stapp02                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
stapp03                    : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Step 7: Verify the Installation

Verify httpd is installed:
Check if httpd package is installed
ansible -i inventory all -m command -a "rpm -q httpd" -b

Verify httpd service is running and enabled:

Check httpd service status
ansible -i inventory all -m shell -a "systemctl status httpd | grep Active" -b

Check if httpd is enabled at boot
ansible -i inventory all -m shell -a "systemctl is-enabled httpd" -b

Verify httpd is running
ansible -i inventory all -m service -a "name=httpd" -b

Expected output:
stapp01 | CHANGED | rc=0 >>
enabled

stapp02 | CHANGED | rc=0 >>
enabled

stapp03 | CHANGED | rc=0 >>
enabled


Test the web server:

Test HTTP response from each server
ansible -i inventory all -m shell -a "curl -s http://localhost | head -5" -b







