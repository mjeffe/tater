# Playbook 03: SSH and Firewall

Goal: an SSH server reachable only from the local network, plus a UFW
firewall that denies all other inbound traffic.

## Current State

- openssh-server is NOT installed. openssh-client is installed.
- UFW is NOT installed.
- No inbound SSH is currently possible, and no firewall is active.
  Note: README.md currently claims an OpenSSH server is configured.
  That is wrong and should be corrected once this playbook is applied.

## Steps

1. Install the SSH server.

   Reference:

       sudo apt install -y openssh-server

2. Restrict SSH to the local network.

   Back up the config first:

       sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig

   Then append a Match block. The subnet below is a placeholder. Use the
   actual LAN subnet, which is tighter and safer than a broad /16.

       Match Address 192.168.0.0/16
           AllowUsers mjeffe
       Match All

   Do not expose SSH to the internet.

3. Enable and start SSH.

       sudo systemctl enable --now ssh

4. Install and configure UFW.

       sudo apt install -y ufw
       sudo ufw default deny incoming
       sudo ufw default allow outgoing
       sudo ufw allow from 192.168.0.0/16 to any port 22 proto tcp
       sudo ufw --force enable

## Desired State

- Package openssh-server: installed.
- Service ssh: enabled and active.
  Check: systemctl is-enabled ssh; systemctl is-active ssh
- /etc/ssh/sshd_config: has a Match Address block for the LAN subnet
  with AllowUsers mjeffe, closed by Match All.
  Check: grep -A3 'Match Address' /etc/ssh/sshd_config
- Package ufw: installed.
- Firewall: active, default incoming denied, default outgoing allowed.
  Check: sudo ufw status verbose
- Firewall: allows port 22 tcp only from the LAN subnet.
  Check: sudo ufw status verbose
- ssh mjeffe@mediaman works from another LAN host.
- A connection attempt from outside the LAN is refused.

## Gotchas

- Determine the real LAN subnet before choosing the Match Address and
  UFW rule. A /24 is tighter than a /16 if the network is small.
- Apply the restriction before enabling SSH. Do not start SSH wide open.
- The firewall and the sshd Match block are defense in depth. Keep both.
- This machine has no static IP yet (see docs/roadmap.md). SSH by
  hostname works via mDNS, but a reserved IP on the router makes it
  predictable.
