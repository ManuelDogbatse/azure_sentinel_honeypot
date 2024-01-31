#!/bin/bash

# Environment variables
ENV="./ports.env"
SSH_PORT="$(sed -n '/SSH_PORT/p' "$ENV" | awk -F '=' '{print $2}')"
KNOCK_1="$(sed -n '/KNOCK_1/p' "$ENV" | awk -F '=' '{print $2}')"
KNOCK_2="$(sed -n '/KNOCK_2/p' "$ENV" | awk -F '=' '{print $2}')"
KNOCK_3="$(sed -n '/KNOCK_3/p' "$ENV" | awk -F '=' '{print $2}')"
KNOCK_4="$(sed -n '/KNOCK_4/p' "$ENV" | awk -F '=' '{print $2}')"
user="$(echo "$PWD" | awk -F '/' '{print $3}')"

# SSH SERVER SETUP
# Change SSH server port and restart
echo "Setting up real SSH server"
printf "Port %s\nPasswordAuthentication yes\nPermitRootLogin no\n" "$SSH_PORT" > /etc/ssh/sshd_config.d/custom_config.conf
systemctl restart sshd
printf "Opened SSH server on port $SSH_PORT\n"

# DOCKER INSTALL
echo "Installing Docker"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do apt-get remove $pkg; done

# Add Docker's official GPG key:
apt-get update
apt-get install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
usermod -aG docker "$user"
printf "Successfully installed Docker\n"

# IPTABLES SETUP
echo "Setting up iptables firewall rules"
# Reset iptables rules and chains
iptables -F
iptables -X
# Add Docker iptables rules and chains for honeypot
service docker restart

# Allow current sessions to avoid ending SSH sessions
# Also allow loopback address packets and ICMP packets
iptables -A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT

# Set INPUT and FORWARD chains to DROP, and OUTPUT to ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Create KNOCKING chain for port knocking
iptables -N KNOCKING

# Send rest of packets to KNOCKING chain
iptables -A INPUT -j KNOCKING

# Check if latest packet's ip has a name of knockfinal in the last 60 seconds. If so, accept the packet
iptables -A KNOCKING -p tcp --dport $SSH_PORT -m recent --rcheck --seconds 60 --reap --name knockfinal -j ACCEPT
# Knocks
iptables -A KNOCKING -p tcp -m tcp --dport $KNOCK_1 -m recent --set --name knock1 -j DROP
iptables -A KNOCKING -p tcp -m recent --rcheck --seconds 10 --reap --name knock1 -m tcp --dport $KNOCK_2 -m recent --set --name knock2 -j DROP
iptables -A KNOCKING -p tcp -m recent --rcheck --seconds 10 --reap --name knock2 -m tcp --dport $KNOCK_3 -m recent --set --name knock3 -j DROP
iptables -A KNOCKING -p tcp -m recent --rcheck --seconds 10 --reap --name knock3 -m tcp --dport $KNOCK_4 -m recent --set --name knockfinal -j DROP

printf "Successfully setup iptables firewall\n"
# Make new rules and chains persistent on reboot
echo "Saving iptables firewall rules"
apt install iptables-persistent -y
sh -c "iptables-save > /etc/iptables/rules.v4"
printf "Successfully saved iptables firewall rules\n"