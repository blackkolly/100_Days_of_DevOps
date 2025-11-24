The Nautilus DevOps team wants to install and set up a simple httpd web server on all app servers in Stratos DC. Additionally, they want to deploy
a sample web page for now using Ansible only. Therefore, write the required playbook to complete this task. Find more details about the task below.

We already have an inventory file under /home/thor/ansible directory on jump host. Create a playbook.yml under /home/thor/ansible directory on jump host itself.
Using the playbook, install httpd web server on all app servers. Additionally, make sure its service should up and running.
Using blockinfile Ansible module add some content in /var/www/html/index.html file. Below is the content:

Welcome to XfusionCorp!
This is  Nautilus sample file, created using Ansible!
Please do not modify this file manually!
The /var/www/html/index.html file's user and group owner should be apache on all app servers.
The /var/www/html/index.html file's permissions should be 0644 on all app servers.

Note:
i. Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.
ii. Do not use any custom or empty marker for blockinfile module.



Step 1: Navigate to Ansible Directory
cd /home/thor/ansible
Step 2: Check the Existing Inventory

Check if inventory file exists
cat inventory

# If it doesn't exist or needs updating, create it
cat > inventory << 'EOF'
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Step 3: Create the Playbook

Create the playbook with all required tasks:

cat > /home/thor/ansible/playbook.yml << 'EOF'
- name: Install and configure httpd web server on all app servers
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
    
    - name: Add content to index.html using blockinfile
      blockinfile:
        path: /var/www/html/index.html
        create: yes
        block: |
          Welcome to XfusionCorp!
          This is Nautilus sample file, created using Ansible!
          Please do not modify this file manually!
    
    - name: Set owner and group for index.html
      file:
        path: /var/www/html/index.html
        owner: apache
        group: apache
        mode: '0644'
EOF


Step 4: Verify the Files

Check inventory
cat /home/thor/ansible/inventory

Check playbook
cat /home/thor/ansible/playbook.yml

Verify playbook syntax
ansible-playbook -i inventory playbook.yml --syntax-check


Step 5: Test Connectivity

Test connection to all app servers
ansible -i inventory all -m ping

Step 6: Run the Playbook
cd /home/thor/ansible
ansible-playbook -i inventory playbook.yml

Expected output:
```
PLAY [Install and configure httpd web server on all app servers] ********************

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

TASK [Add content to index.html using blockinfile] **********************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [Set owner and group for index.html] ********************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

PLAY RECAP ***************************************************************************
stapp01                    : ok=5    changed=4    unreachable=0    failed=0
stapp02                    : ok=5    changed=4    unreachable=0    failed=0
stapp03                    : ok=5    changed=4    unreachable=0    failed=0
```

Step 7: Verify the Deployment

Verify httpd is running:

Check httpd service status
ansible -i inventory all -m shell -a "systemctl status httpd | grep Active" -b

Check if httpd is enabled
ansible -i inventory all -m shell -a "systemctl is-enabled httpd" -b

Verify index.html content:

Check file content
ansible -i inventory all -m command -a "cat /var/www/html/index.html" -b

Check file permissions and ownership
ansible -i inventory all -m command -a "ls -la /var/www/html/index.html" -b

Expected output for file details:
```
-rw-r--r-- 1 apache apache [size] [date] /var/www/html/index.html
```

Test the web server:
# Test HTTP response from each server
ansible -i inventory all -m shell -a "curl -s http://localhost" -b

# Or test from jump host if port 80 is accessible
curl http://172.16.238.10
curl http://172.16.238.11
curl http://172.16.238.12


