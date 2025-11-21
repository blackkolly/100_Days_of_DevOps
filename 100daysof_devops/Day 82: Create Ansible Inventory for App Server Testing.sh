The Nautilus DevOps team is testing Ansible playbooks on various servers within their stack. They've placed some playbooks under `/home/thor/playbook/` directory on the `jump host` and now intend to test them on `app server 3` in `Stratos DC`. However, an inventory file needs creation for Ansible to connect to the respective app. Here are the requirements:
a. Create an ini type Ansible inventory file `/home/thor/playbook/inventory` on `jump host`.
b. Include `App Server 3` in this inventory along with necessary variables for proper functionality.
c. Ensure the inventory hostname corresponds to the `server name` as per the wiki, for example `stapp01` for `app server 1` in `Stratos DC`.
`Note:` Validation will execute the playbook using the command `ansible-playbook -i inventory playbook.yml`. Ensure the playbook functions properly without any extra arguments.



Solution: Create Ansible Inventory for App Server 3

Based on your infrastructure details, I'll create the Ansible inventory file for **App Server 3** (stapp03).

Step 1: Navigate to the Playbook Directory

On jump host
cd /home/thor/playbook/


 Step 2: Create the Inventory File

Create the inventory file with the correct configuration:

cat > /home/thor/playbook/inventory << 'EOF'
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=BigGr33n ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Alternative: Using vi/nano

If you prefer to use an editor:
vi /home/thor/playbook/inventory

Add this content:

ini
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=BigGr33n ansible_ssh_common_args='-o StrictHostKeyChecking=no'

Save and exit (`:wq` in vi).

Step 3: Verify the Inventory File
Check the file contents
cat /home/thor/playbook/inventory
 Verify file permissions
ls -la /home/thor/playbook/inventory

Step 4: Test the Inventory

Test connectivity to App Server 3:

Test with ansible ping module
ansible -i inventory stapp03 -m ping

You should see output like:
stapp03 | SUCCESS => {
    "changed": false,
    "ping": "pong"
 }

Step 5: Test the Playbook Execution

Run the playbook (assuming there's a playbook.yml in the directory)
ansible-playbook -i inventory playbook.yml

Complete Inventory File Explanation

stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=BigGr33n ansible_ssh_common_args='-o StrictHostKeyChecking=no'

Breaking down the variables:

- `stapp03` - Inventory hostname (matches server name as per wiki)
- `ansible_host=172.16.238.12` - IP address of App Server 3
- `ansible_user=banner` - SSH username for App Server 3
- `ansible_password=BigGr33n` - SSH password for user banner
- `ansible_ssh_common_args='-o StrictHostKeyChecking=no'` - Disables SSH host key checking (for lab environment)

Alternative Inventory Formats

Option 1: With Group (Recommended for scalability)

```ini
[app_servers]
stapp03 ansible_host=172.16.238.12 ansible_user=banner ansible_password=BigGr33n

[app_servers:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

Option 2: More Verbose Format

ini
[app_servers]
stapp03

[app_servers:vars]
ansible_host=172.16.238.12
ansible_user=banner
ansible_password=BigGr33n
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

