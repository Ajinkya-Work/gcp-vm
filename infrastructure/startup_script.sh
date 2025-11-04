#!/bin/bash
set -euxo pipefail

# Wait for apt locks and update packages
while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
  echo "Waiting for apt lock..."
  sleep 5
done

apt-get update -y
apt-get upgrade -y
apt-get install -y nginx

systemctl enable nginx
systemctl start nginx

echo "NGINX installed and running successfully" | tee /var/log/startup-script.log
