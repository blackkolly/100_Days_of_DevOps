The Nautilus DevOps team needs to set up several docker environments for different applications. One of the team members 
has been assigned a ticket where he has been asked to create some docker networks to be used later. Complete the task based on 
the following ticket description:

a. Create a docker network named as ecommerce on App Server 3 in Stratos DC.
b. Configure it to use bridge drivers.
c. Set it to use subnet 172.168.0.0/24 and iprange 172.168.0.0/24.


Step 1 — Verify Docker is running

Make sure Docker is installed and active:

sudo systemctl status docker

If it’s not running:

sudo systemctl start docker
sudo systemctl enable docker

Step 2 — Create the Docker network

Run this command exactly as written:

sudo docker network create \
  --driver bridge \
  --subnet 172.168.0.0/24 \
  --ip-range 172.168.0.0/24 \
  ecommerce

Step 3 — Verify the network

Check that the network was created successfully:

sudo docker network ls

You should see an entry like:
NETWORK ID     NAME        DRIVER    SCOPE
xxxxxxxxxxxx   ecommerce   bridge    local

Step 4 — Inspect the details

Confirm the subnet and IP range:
sudo docker network inspect ecommerce
Expected output (trimmed for clarity):

json
[
    {
        "Name": "ecommerce",
        "Driver": "bridge",
        "IPAM": {
            "Config": [
                {
                    "Subnet": "172.168.0.0/24",
                    "IPRange": "172.168.0.0/24"
                }
            ]
        }
    }
]

