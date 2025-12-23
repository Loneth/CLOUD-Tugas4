#!/bin/bash

S3="daedaedae"
PROJECT="/home/ubuntu/app"
REPO="https://github.com/Loneth/CLOUD-Tugas4"

apt-get update -yq
apt-get install -yq ca-certificates curl unzip gnupg lsb-release

if ! command -v aws &>/dev/null || [[ "$(aws --version 2>&1)" < "aws-cli/2" ]]; then
  curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip -q /tmp/awscliv2.zip -d /tmp
  /tmp/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
  rm -rf /tmp/aws /tmp/awscliv2.zip
fi

if ! command -v docker &>/dev/null; then
  install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null
  chmod a+r /etc/apt/keyrings/docker.asc
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

  apt-get update -yq
  apt-get install -yq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

systemctl enable --now docker

usermod -aG docker $USER
usermod -aG docker ubuntu

mkdir -p "$PROJECT"
cd "$PROJECT"

git clone "${REPO}" temp
cp -pRn temp/. .
rm -rf temp

aws s3 cp "s3://${S3}/private/tugas3.env" .env

find "$PROJECT" -type d -exec chmod 777 {} \;
find "$PROJECT" -type f -exec chmod 777 {} \;

echo "done"
