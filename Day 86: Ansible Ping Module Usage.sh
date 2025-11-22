The Nautilus DevOps team is planning to test several Ansible playbooks on different app servers in Stratos DC. Before that, some pre-requisites must be met. Essentially, the team needs to set up a password-less SSH connection between Ansible controller and Ansible managed nodes. One of the tickets is assigned to you; please complete the task as per details mentioned below:


a. Jump host is our Ansible controller, and we are going to run Ansible playbooks through thor user from jump host.


b. There is an inventory file /home/thor/ansible/inventory on jump host. Using that inventory file test Ansible ping from jump host to App Server 1, make sure ping works.


 Step 1: Generate SSH key (if not exists)
if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa
fi

Step 2: Display public key
echo "Your public key:"
cat ~/.ssh/id_rsa.pub

Step 3: Copy SSH key to App Server 1
ssh-copy-id -o StrictHostKeyChecking=no tony@stapp01
# Enter password when prompted: Ir0nM@n

Step 4: Test SSH connection (should work without password)
ssh tony@stapp01 'hostname'

Step 5: Ensure inventory file exists
mkdir -p ~/ansible
cat > ~/ansible/inventory << 'EOF'
stapp01 ansible_host=172.16.238.10 ansible_user=tony ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF

Step 6: Test Ansible ping
ansible -i ~/ansible/inventory stapp01 -m ping
