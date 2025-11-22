The Nautilus Application development team wanted to test some applications on app servers in Stratos Datacenter. They shared some pre-requisites with the DevOps team, and packages need to be 
installed on app servers. Since we are already using Ansible for automating such tasks, please perform this task using Ansible as per details mentioned below:

Create an inventory file /home/thor/playbook/inventory on jump host and add all app servers in it.
Create an Ansible playbook /home/thor/playbook/playbook.yml to install samba package on all  app servers using Ansible yum module.
Make sure user thor should be able to run the playbook on jump host.
Note: Validation will try to run playbook using command ansible-playbook -i inventory playbook.yml so please make sure playbook works this way, without passing any extra arguments.


Solution: Install Samba Package on All App Servers Using Ansible



Step 1: Setup Password-less SSH (Pre-requisite)

First, ensure password-less SSH is set up from jump host to all app servers:

As thor user on jump host
cd ~

Generate SSH key if not exists
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa
fi

Copy SSH key to all app servers
ssh-copy-id tony@stapp01
Password: Ir0nM@n

ssh-copy-id steve@stapp02
 Password: Am3ric@

ssh-copy-id banner@stapp03
Password: BigGr33n

Test SSH connections (should work without password)
ssh tony@stapp01 'hostname'
ssh steve@stapp02 'hostname'
ssh banner@stapp03 'hostname'

Step 2: Create the Playbook Directory

Create directory
mkdir -p /home/thor/playbook
cd /home/thor/playbook

Step 3: Create the Inventory File

Create the inventory with all three application servers:

cat > inventory << 'EOF'
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Step 4: Create the Ansible Playbook

Create the playbook to install Samba using the yum module:

cat > playbook.yml << 'EOF'
---
- name: Install Samba package on all app servers
  hosts: all
  become: yes
  gather_facts: yes
  tasks:
    - name: Install samba package using yum
      yum:
        name: samba
        state: present
      environment:
        LANG: C
        LC_ALL: C
EOF

Step 5: Verify the Files
Check inventory
cat /home/thor/playbook/inventory

Check playbook
cat /home/thor/playbook/playbook.yml

Verify file ownership (should be thor)
ls -la /home/thor/playbook/

Step 6: Test Ansible Connectivity

cd /home/thor/playbook

Test connectivity to all app servers
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


Step 7: Run the Playbook

Execute the playbook to install Samba:

ansible-playbook -i inventory playbook.yml


Expected output:
```
PLAY [Install Samba package on all app servers] ********************************

TASK [Gathering Facts] **********************************************************
ok: [stapp01]
ok: [stapp02]
ok: [stapp03]

TASK [Install samba package using yum] *****************************************
changed: [stapp01]
changed: [stapp02]
changed: [stapp03]

PLAY RECAP **********************************************************************
stapp01                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
stapp02                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
stapp03                    : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


