There are some files that need to be created on all app servers in Stratos DC. The Nautilus DevOps team want these files to be owned by user root only however, 
they also want that the app specific user to have a set of permissions on these files. All tasks must be done using Ansible only, so they need to create a playbook. Below you can find more information about the task.

Create a playbook named playbook.yml under /home/thor/ansible directory on jump host, an inventory file is already present under /home/thor/ansible directory on
Jump Server itself.

Create an empty file blog.txt under /opt/security/ directory on app server 1. Set some acl properties for this file. Using acl provide read '(r)' permissions to
group tony (i.e entity is tony and etype is group).
Create an empty file story.txt under /opt/security/ directory on app server 2. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions 
to user steve (i.e entity is steve and etype is user).

Create an empty file media.txt under /opt/security/ on app server 3. Set some acl properties for this file. Using acl provide read + write '(rw)' permissions to
group banner (i.e entity is banner and etype is group).

Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way, without
passing any extra arguments.


Step 1: Navigate to Ansible Directory

cd /home/thor/ansible

Step 2: Check the Existing Inventory

Check inventory file
cat inventory

If the inventory needs updating:
cat > /home/thor/ansible/inventory << 'EOF'
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_ssh_common_args='-o StrictHostKeyChecking=no'
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Step 3: Create the Playbook

Create the playbook with ACL configurations for each server:

cat > /home/thor/ansible/playbook.yml << 'EOF'

- name: Create blog.txt with ACL on App Server 1
  hosts: stapp01
  become: yes
  tasks:
    - name: Ensure /opt/security directory exists
      file:
        path: /opt/security
        state: directory
        owner: root
        group: root
        mode: '0755'
    
    - name: Create empty file blog.txt
      file:
        path: /opt/security/blog.txt
        state: touch
        owner: root
        group: root
        mode: '0644'
    
    - name: Set ACL for group tony on blog.txt
      acl:
        path: /opt/security/blog.txt
        entity: tony
        etype: group
        permissions: r
        state: present

- name: Create story.txt with ACL on App Server 2
  hosts: stapp02
  become: yes
  tasks:
    - name: Ensure /opt/security directory exists
      file:
        path: /opt/security
        state: directory
        owner: root
        group: root
        mode: '0755'
    
    - name: Create empty file story.txt
      file:
        path: /opt/security/story.txt
        state: touch
        owner: root
        group: root
        mode: '0644'
    
    - name: Set ACL for user steve on story.txt
      acl:
        path: /opt/security/story.txt
        entity: steve
        etype: user
        permissions: rw
        state: present

- name: Create media.txt with ACL on App Server 3
  hosts: stapp03
  become: yes
  tasks:
    - name: Ensure /opt/security directory exists
      file:
        path: /opt/security
        state: directory
        owner: root
        group: root
        mode: '0755'
    
    - name: Create empty file media.txt
      file:
        path: /opt/security/media.txt
        state: touch
        owner: root
        group: root
        mode: '0644'
    
    - name: Set ACL for group banner on media.txt
      acl:
        path: /opt/security/media.txt
        entity: banner
        etype: group
        permissions: rw
        state: present
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

PLAY [Create blog.txt with ACL on App Server 1] *************************************

TASK [Gathering Facts] ***************************************************************
ok: [stapp01]

TASK [Ensure /opt/security directory exists] ****************************************
changed: [stapp01]

TASK [Create empty file blog.txt] ****************************************************
changed: [stapp01]

TASK [Set ACL for group tony on blog.txt] ********************************************
changed: [stapp01]

PLAY [Create story.txt with ACL on App Server 2] ************************************

TASK [Gathering Facts] ***************************************************************
ok: [stapp02]

TASK [Ensure /opt/security directory exists] ****************************************
changed: [stapp02]

TASK [Create empty file story.txt] ***************************************************
changed: [stapp02]

TASK [Set ACL for user steve on story.txt] *******************************************
changed: [stapp02]

PLAY [Create media.txt with ACL on App Server 3] ************************************

TASK [Gathering Facts] ***************************************************************
ok: [stapp03]

TASK [Ensure /opt/security directory exists] ****************************************
changed: [stapp03]

TASK [Create empty file media.txt] ***************************************************
changed: [stapp03]

TASK [Set ACL for group banner on media.txt] *****************************************
changed: [stapp03]

PLAY RECAP ***************************************************************************
stapp01                    : ok=4    changed=3    unreachable=0    failed=0
stapp02                    : ok=4    changed=3    unreachable=0    failed=0
stapp03                    : ok=4    changed=3    unreachable=0    failed=0
```

Step 7: Verify the Configuration

Verify files exist with correct ownership:

Check files on all servers
ansible -i inventory stapp01 -m command -a "ls -la /opt/security/blog.txt" -b
ansible -i inventory stapp02 -m command -a "ls -la /opt/security/story.txt" -b
ansible -i inventory stapp03 -m command -a "ls -la /opt/security/media.txt" -b

Verify ACL permissions:
Check ACL on stapp01 (blog.txt - group tony with read)
ansible -i inventory stapp01 -m command -a "getfacl /opt/security/blog.txt" -b

Check ACL on stapp02 (story.txt - user steve with read+write)
ansible -i inventory stapp02 -m command -a "getfacl /opt/security/story.txt" -b

Check ACL on stapp03 (media.txt - group banner with read+write)
ansible -i inventory stapp03 -m command -a "getfacl /opt/security/media.txt" -b


Expected output for blog.txt on stapp01:

file: /opt/security/blog.txt
owner: root
group: root
user::rw-
group::r--
group:tony:r--
mask::r--
other::r--


Expected output for story.txt on stapp02:**

file: /opt/security/story.txt
owner: root
group: root
user::rw-
user:steve:rw-
group::r--
mask::rw-
other::r--


Expected output for media.txt on stapp03:

file: /opt/security/media.txt
owner: root
group: root
user::rw-
group::r--
group:banner:rw-
mask::rw-
other::r--


