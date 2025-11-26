One of the Nautilus DevOps team members is working on to develop a role for httpd installation and configuration. Work is almost completed, however there is a requirement 
to add a jinja2 template for index.html file. Additionally, the relevant task needs to be added inside the role. The inventory file ~/ansible/inventory is 
already present on jump host that can be used. Complete the task as per details mentioned below:

a. Update ~/ansible/playbook.yml playbook to run the httpd role on App Server 3.
b. Create a jinja2 template index.html.j2 under /home/thor/ansible/role/httpd/templates/ directory and add a line This file was created using Ansible on <respective server> (for example This file was created using Ansible on stapp01 in case of App Server 1). Also please make sure not to hard code the server name inside the template. Instead, use inventory_hostname variable to fetch the correct value.
c. Add a task inside /home/thor/ansible/role/httpd/tasks/main.yml to copy this template on App Server 3 under /var/www/html/index.html. Also make sure that /var/www/html/index.html file's permissions are 0744.

d. The user/group owner of /var/www/html/index.html file must be respective sudo user of the server (for example tony in case of stapp01).
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml so please make sure the playbook works this way without passing any extra arguments.


Step 1: Navigate to Ansible Directory

cd ~/ansible

Step 2: Check Existing Structure
Check the current directory structure
tree ~/ansible/
 Or list the directories
ls -la ~/ansible/
ls -la ~/ansible/role/
ls -la ~/ansible/role/httpd/

Step 3: Update the Playbook

Update `~/ansible/playbook.yml` to run the httpd role on App Server 3 (stapp03):

cat > ~/ansible/playbook.yml << 'EOF'
- name: Run httpd role on App Server 3
  hosts: stapp03
  become: yes
  roles:
    - httpd
EOF


Step 4: Create the Jinja2 Template

cat > ~/ansible/role/httpd/templates/index.html.j2 << 'EOF'
This file was created using Ansible on {{ inventory_hostname }}
EOF


Step 5: Update the Role Tasks

Add the template task to `/home/thor/ansible/role/httpd/tasks/main.yml`:
 First, check what's already in the file
cat ~/ansible/role/httpd/tasks/main.yml

# Append the new task to the existing tasks
cat >> ~/ansible/role/httpd/tasks/main.yml << 'EOF'
---
# tasks file for role/httpd

- name: Install the latest version of HTTPD
  yum:
    name: httpd
    state: latest

- name: Start service httpd
  service:
    name: httpd
    state: started

- name: Deploy index.html from template
  template:
    src: index.html.j2
    dest: /var/www/html/index.html
    owner: "{{ ansible_user }}"
    group: "{{ ansible_user }}"
    mode: '0655'
EOF


 Step 6: Verify the Inventory

cat ~/ansible/inventory
cat ~/ansible/playbook.yml
cat ~/ansible/role/httpd/templates/index.html.j2
cat ~/ansible/role/httpd/tasks/main.yml


Step 7 — Create a symlink**


cd /home/thor/ansible
ln -s role roles
ansible/
├── inventory
├── playbook.yml
├── role/
│   └── httpd/
│       ├── tasks/main.yml
│       └── templates/index.html.j2
└── roles -> role

ls -l
roles -> role


Step 8: Test the Playbook

cd ~/ansible
ansible-playbook -i inventory playbook.yml --syntax-check
ansible-playbook -i inventory playbook.yml --check

Run the playbook
ansible-playbook -i inventory playbook.yml
