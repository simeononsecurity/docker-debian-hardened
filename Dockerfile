FROM debian:latest

LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/docker-debian-hardened"
LABEL org.opencontainers.image.description="Hardened Debian Docker Container with arm, arm64, and amd64 support"
LABEL org.opencontainers.image.authors="simeononsecurity"

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV TERM=xterm

# Update Packages
RUN apt-get update && \
  apt-get -y --no-install-recommends install apt-utils && \
  apt-get -fuy --no-install-recommends full-upgrade -y && \ 
  apt-get -fuy --no-install-recommends install git aide iptables ufw dnsutils apparmor kmod systemd automake net-tools procps cmake make python3 python3-pip python3-dev

# Install Ansible
RUN echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main' > /etc/apt/sources.list.d/ansible.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && apt update && apt-get install -y ansible

# Download and run konstruktoid.hardening Playbook
RUN git clone https://github.com/simeononsecurity/docker-debian-hardened.git
RUN cd /docker-debian-hardened/ && chmod +x ./dockersetup.sh
RUN cd /docker-debian-hardened/ && bash ./dockersetup.sh

# Clean Up Apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/bin/bash" ]
