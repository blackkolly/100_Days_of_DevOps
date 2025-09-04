During the weekly meeting, the Nautilus DevOps team discussed about the automation and configuration management solutions that they want to implement. While considering several options, the team has decided to go with Ansible for now due to its simple setup and minimal pre-requisites. The team wanted to start testing using Ansible, so they have decided to use jump host as an Ansible controller to test different kind of tasks on rest of the servers.

Install ansible version 4.9.0 on Jump host using pip3 only. Make sure Ansible binary is available globally on this system, i.e all users on this system are able to run Ansible commands.

1. SSH into jump host
ssh thor@jump_host.stratos.xfusioncorp.com

Password: mjolnir123

2. Ensure pip3 is installed

On most systems:

sudo yum install -y python3-pip   # (RHEL/CentOS)
# or
sudo apt-get update && sudo apt-get install -y python3-pip  # (Ubuntu/Debian)

3. Install Ansible 4.9.0 with pip3 globally
sudo pip3 install ansible==4.9.0


# Using sudo ensures the package is installed into the system-wide Python environment, making ansible available to all users.

4. Verify installation

Check version:

ansible --version

Expected output (similar to):

ansible [core 2.11.6]
  config file = None
  python version = 3.x.x
