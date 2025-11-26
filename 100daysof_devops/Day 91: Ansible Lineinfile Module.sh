The Nautilus DevOps team want to install and set up a simple httpd web server on all app servers in Stratos DC. They also want to deploy a sample web page using Ansible. Therefore, write the required playbook to complete this task as per details mentioned below.
We already have an inventory file under /home/thor/ansible directory on jump host. Write a playbook playbook.yml under /home/thor/ansible directory on jump host itself. Using the playbook perform below given tasks:
1. Install httpd web server on all app servers, and make sure its service is up and running.
2. Create a file /var/www/html/index.html with content:
This is a Nautilus sample file, created using Ansible!
1. Using lineinfile Ansible module add some more content in /var/www/html/index.html file. Below is the content:
Welcome to Nautilus Group!
Also make sure this new line is added at the top of the file.
1. The /var/www/html/index.html file's user and group owner should be apache on all app servers.
2. The /var/www/html/index.html file's permissions should be 0655 on all app servers.
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.




Step 1: Navigate to Ansible Directory

cd /home/thor/ansible

Step 2: Check the Existing Inventory

Check if inventory file exists
cat inventory

If it doesn't exist or needs updating:
cat > /home/thor/ansible/inventory << 'EOF'
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
    
    - name: Create index.html with initial content
      copy:
        content: "This is a Nautilus sample file, created using Ansible!\n"
        dest: /var/www/html/index.html
        owner: apache
        group: apache
        mode: '0655'
    
    - name: Add additional content at the top of index.html using lineinfile
      lineinfile:
        path: /var/www/html/index.html
        line: "Welcome to Nautilus Group!"
        insertbefore: BOF
        owner: apache
        group: apache
        mode: '0655'
EOF

Step 4: Verify the Files

Check inventory
cat /home/thor/ansible/inventory

Check playbook
cat /home/thor/ansible/playbook.yml

Verify playbook syntax
ansible-playbook -i inventory playbook.yml --syntax-check

Step 5: Test Connectivity
cd /home/thor/ansible

Test connection to all app servers
ansible -i inventory all -m ping

Step 6: Run the Playbook
ansible-playbook -i inventory playbook.yml

Expected output:

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

TASK [Create index.html with initial content] ***************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

TASK [Add additional content at the top of index.html using lineinfile] *************
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

Expected content:**
```
Welcome to Nautilus Group!
This is a Nautilus sample file, created using Ansible!

Verify file permissions and ownership:
Check file permissions and ownership
ansible -i inventory all -m command -a "ls -la /var/www/html/index.html" -b

Expected output:

-rw-r-xr-x 1 apache apache [size] [date] /var/www/html/index.html


Test the web server:

Test HTTP response from each server
ansible -i inventory all -m shell -a "curl -s http://localhost" -b
```

