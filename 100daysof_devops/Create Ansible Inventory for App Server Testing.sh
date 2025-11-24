The Nautilus DevOps team is testing Ansible playbooks on various servers within their stack. They've placed some playbooks under /home/thor/playbook/ 
directory on the jump host and now intend to test them on app server 2 in Stratos DC. However, an inventory file needs creation for Ansible to connect to the respective app. Here are the requirements:

a. Create an ini type Ansible inventory file /home/thor/playbook/inventory on jump host.
b. Include App Server 2 in this inventory along with necessary variables for proper functionality.
c. Ensure the inventory hostname corresponds to the server name as per the wiki, for example stapp01 for app server 1 in Stratos DC.
Note: Validation will execute the playbook using the command ansible-playbook -i inventory playbook.yml. Ensure the playbook functions properly without 
any extra arguments.

Solution: Create Ansible Inventory for App Server 2

Based on your infrastructure details, I'll create the Ansible inventory file for App Server 2 (stapp02).

Step 1: Navigate to the Playbook Directory

# On jump host
cd /home/thor/playbook/

Step 2: Create the Inventory File

Create the inventory file with the correct configuration for App Server 2:

cat > /home/thor/playbook/inventory << 'EOF'
stapp02 ansible_host=172.16.238.11 ansible_user=steve ansible_password=Am3ric@ ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF


Step 3: Verify the Inventory File

Check the file contents
cat /home/thor/playbook/inventory

Verify file permissions
ls -la /home/thor/playbook/inventory


Step 4: Test the Inventory

Test connectivity to App Server 2:

Test with ansible ping module
ansible -i inventory stapp02 -m ping


Step 5: Test the Playbook Execution
ansible-playbook -i inventory playbook.yml





