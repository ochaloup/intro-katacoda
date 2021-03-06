#!/usr/bin/env bash

# Install and Configure Docker
#
#

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

yum install -y docker

# Confiugure the Docker registry to get access to the needed repositories
echo "[INFO] Enabling Docker registries"
cat << EOF > /etc/sysconfig/docker
# Configured by Vagrant
DOCKER_CERT_PATH=/etc/docker
OPTIONS="--selinux-enabled -H tcp://0.0.0.0:2345 -H unix:///var/run/docker.sock"

# INSECURE_REGISTRY and ADD_REGISTRY are used by systemcdl scripts. They are a RHEL feature.
# See http://rhelblog.redhat.com/2015/04/15/understanding-the-changes-to-docker-search-and-docker-pull-in-red-hat-enterprise-linux-7-1/
#
# registry.access.redhat.com - Main Red Hat registry
ADD_REGISTRY='--add-registry registry.access.redhat.com'
INSECURE_REGISTRY='--insecure-registry registry.access.redhat.com --insecure-registry 172.30.0.0/16'
EOF

systemctl restart docker
systemctl enable docker
