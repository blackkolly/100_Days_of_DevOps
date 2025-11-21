The Nautilus DevOps team is testing various Ansible modules on servers in Stratos DC. They're currently focusing on file creation on remote hosts using Ansible.
Here are the details:

a. Create an inventory file ~/playbook/inventory on jump host and include all app servers.

b. Create a playbook ~/playbook/playbook.yml to create a blank file /tmp/webapp.txt on all app servers.

c. Set the permissions of the /tmp/webapp.txt file to 0777.

d. Ensure the user/group owner of the /tmp/webapp.txt file is tony on app server 1, steve on app server 2 and banner on app server 3.

Note: Validation will execute the playbook using the command ansible-playbook -i inventory playbook.yml, so ensure the playbook functions correctly without 
any additional arguments.


Solution: Create File with Specific Permissions and Ownership on All App Servers

Step 1: Create the Playbook Directory


# Create directory
mkdir -p ~/playbook
cd ~/playbook


Step 2: Create the Inventory File

Create the inventory with all three application servers:

cat > ~/playbook/inventory << 'EOF'
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_password=Ir0nM@n ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=Am3ric@ ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=BigGr33n ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Step 3: Create the Playbook

Create the playbook with different ownership for each server:

cat > ~/playbook/playbook.yml << 'EOF'

- name: Create webapp.txt file on App Server 1
  hosts: stapp01
  become: yes
  tasks:
    - name: Create /tmp/webapp.txt with tony as owner
      file:
        path: /tmp/webapp.txt
        state: touch
        mode: '0777'
        owner: tony
        group: tony

- name: Create webapp.txt file on App Server 2
  hosts: stapp02
  become: yes
  tasks:
    - name: Create /tmp/webapp.txt with steve as owner
      file:
        path: /tmp/webapp.txt
        state: touch
        mode: '0777'
        owner: steve
        group: steve

- name: Create webapp.txt file on App Server 3
  hosts: stapp03
  become: yes
  tasks:
    - name: Create /tmp/webapp.txt with banner as owner
      file:
        path: /tmp/webapp.txt
        state: touch
        mode: '0777'
        owner: banner
        group: banner
EOF

Step 4: Verify the Files

Check inventory
cat ~/playbook/inventory

 Check playbook
cat ~/playbook/playbook.yml

Step 5: Test Connectivity

cd ~/playbook

Ping all servers
ansible -i inventory all -m ping


 Step 6: Run the Playbook

ansible-playbook -i inventory playbook.yml

Expected output:

PLAY [Create webapp.txt file on App Server 1] **********************************

TASK [Gathering Facts] **********************************************************
ok: [stapp01]

TASK [Create /tmp/webapp.txt with tony as owner] *******************************
changed: [stapp01]

PLAY [Create webapp.txt file on App Server 2] **********************************

TASK [Gathering Facts] **********************************************************
ok: [stapp02]

TASK [Create /tmp/webapp.txt with steve as owner] ******************************
changed: [stapp02]

PLAY [Create webapp.txt file on App Server 3] **********************************

TASK [Gathering Facts] **********************************************************
ok: [stapp03]

TASK [Create /tmp/webapp.txt with banner as owner] *****************************
changed: [stapp03]

PLAY RECAP **********************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0
stapp02                    : ok=2    changed=1    unreachable=0    failed=0
stapp03                    : ok=2    changed=1    unreachable=0    failed=0
```

Step 7: Verify the File Creation

Verify the file exists with correct permissions and ownership:

Check file details on all servers
ansible -i inventory all -m command -a "ls -la /tmp/webapp.txt"
 Expected output:
stapp01 | CHANGED | rc=0 >>
-rwxrwxrwx 1 tony tony 0 Nov 21 23:00 /tmp/webapp.txt
 stapp02 | CHANGED | rc=0 >>
-rwxrwxrwx 1 steve steve 0 Nov 21 23:00 /tmp/webapp.txt

stapp03 | CHANGED | rc=0 >>
 -rwxrwxrwx 1 banner banner 0 Nov 21 23:00 /tmp/webapp.txt


