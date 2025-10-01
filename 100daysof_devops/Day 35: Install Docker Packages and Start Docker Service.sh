The Nautilus DevOps team aims to containerize various applications following a recent meeting with the application development team. 
They intend to conduct testing with the following steps:

Install docker-ce and docker compose packages on App Server 1.
Initiate the docker service.

🔹 Step 1: SSH into App Server 1

From jump host:

ssh tony@stapp01   # password: Ir0nM@n


Switch to root if needed:

sudo -i

🔹 Step 2: Remove old Docker packages (if any)
sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

🔹 Step 3: Set up Docker CE repo
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

🔹 Step 4: Install Docker CE
sudo dnf install -y docker-ce docker-ce-cli containerd.io

🔹 Step 5: Enable & start Docker
sudo systemctl enable --now docker


Check status:

systemctl status docker

🔹 Step 6: Install Docker Compose

On most systems Docker Compose v2 comes bundled, check with:

docker compose version
