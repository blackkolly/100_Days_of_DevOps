The Nautilus DevOps team had a discussion about, how they can train different team members to use Ansible for different automation tasks. There are numerous ways to perform a particular task using Ansible, but we want to utilize each aspect that Ansible offers. The team wants to utilise Ansible's conditionals to perform the following task:
An inventory file is already placed under /home/thor/ansible directory on jump host, with all the Stratos DC app servers included.
Create a playbook /home/thor/ansible/playbook.yml and make sure to use Ansible's when conditionals statements to perform the below given tasks.
1. Copy blog.txt file present under /usr/src/finance directory on jump host to App Server 1 under /opt/finance directory. Its user and group owner must be user tony and its permissions must be 0755 .
2. Copy story.txt file present under /usr/src/finance directory on jump host to App Server 2 under /opt/finance directory. Its user and group owner must be user steve and its permissions must be 0755 .
3. Copy media.txt file present under /usr/src/finance directory on jump host to App Server 3 under /opt/finance directory. Its user and group owner must be user banner and its permissions must be 0755.
NOTE: You can use ansible_nodename variable from gathered facts with when condition. Additionally, please make sure you are running the play for all hosts i.e use - hosts: all.
Note: Validation will try to run the playbook using command ansible-playbook -i inventory playbook.yml, so please make sure the playbook works this way without passing any extra arguments.

Navigate to the ansible directory
cd /home/thor/ansible

# create the playbook as playbook.yml
---
- hosts: all
  become: yes
  tasks:
    - name: Copy blog.txt to App Server 1
      copy:
        src: /usr/src/finance/blog.txt
        dest: /opt/finance/blog.txt
        owner: tony
        group: tony
        mode: '0755'
      when: ansible_nodename == 'stapp01.stratos.xfusioncorp.com'

    - name: Copy story.txt to App Server 2
      copy:
        src: /usr/src/finance/story.txt
        dest: /opt/finance/story.txt
        owner: steve
        group: steve
        mode: '0755'
      when: ansible_nodename == 'stapp02.stratos.xfusioncorp.com'

    - name: Copy media.txt to App Server 3
      copy:
        src: /usr/src/finance/media.txt
        dest: /opt/finance/media.txt
        owner: banner
        group: banner
        mode: '0755'
      when: ansible_nodename == 'stapp03.stratos.xfusioncorp.com'
      
Key Components:

hosts: all - Runs against all servers in the inventory
become: yes - Elevates privileges to perform file operations
Conditional execution using when - Each task only runs on the specific server based on ansible_nodename

How the Conditionals Work:

Task 1: Copies blog.txt to stapp01 only when ansible_nodename matches stapp01.stratos.xfusioncorp.com
Task 2: Copies story.txt to stapp02 only when ansible_nodename matches stapp02.stratos.xfusioncorp.com
Task 3: Copies media.txt to stapp03 only when ansible_nodename matches stapp03.stratos.xfusioncorp.com

File Specifications:

Each file is copied with 0755 permissions
Ownership is set to the respective server's user (tony/steve/banner)
Target directory is /opt/finance/ on each server
# Run the playbook

ansible-playbook -i inventory playbook.yml
