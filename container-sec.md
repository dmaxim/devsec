
# Setup

## Install Docker
````
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce-19.03.11 docker-ce-cli-19.03.11 containerd.io-1.2.13-3.2.el7 jq python3-pip git
sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker "${USER}"
sg docker

docker version

````

## Install Jenkins

````
docker run --rm -d -p 8080:8080 -p 50000:50000 \
--name vuln-jenkins \
-v /var/run/docker.sock:/var/run/docker.sock \
controlplane/jenkins-2.152-cve-2018-1000861-cve-2019-1003000:latest


docker ps


````

## Navigate to Jenkins

