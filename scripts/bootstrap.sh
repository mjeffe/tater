#!/bin/bash
# ============================================================
# Media Machine Bootstrap Script
# ASUS Chromebook "Kefka" / Debian 13 "Trixie"
#
# Purpose: Take a fresh Debian 13 install and configure it as
# a dedicated home media center. Run this script ONCE after
# installing the base Debian system.
#
# What it does (in order):
#   1. Update the system
#   2. Purge GNOME, Evolution, LibreOffice, and other bloat
#   3. Install LXQt lightweight desktop
#   4. Install SSH server (restricted to local network)
#   5. Install media tools (VLC, mpv) and utilities
#   6. Set up external USB drive mount point
#   7. Configure firewall (UFW)
#   8. Final cleanup and disk space report
#
# Usage: bash bootstrap.sh
#
# Note: Phases 2-3 mirror the separate cleanup-and-install-lxqt.sh
# script kept here as a historical reference of the first setup.
# ============================================================
set -e

# --- Configuration (change these as needed) -----------------
HOSTNAME="mediaman"
USERNAME="mjeffe"
MEDIA_MOUNT="/mnt/media"
SSH_ALLOW_NET="192.168.0.0/16"   # local network subnet for SSH
# ------------------------------------------------------------

echo ""
echo "============================================================"
echo " MEDIA MACHINE BOOTSTRAP"
echo " Target: $HOSTNAME / Debian 13 / LXQt"
echo "============================================================"
echo ""

# ============================================================
# PHASE 1: System update
# ============================================================
echo "=== PHASE 1: System update ==="
sudo apt update
sudo apt upgrade -y

# Install a few base utilities we will need throughout
sudo apt install -y curl wget gpg 2>/dev/null || true

# ============================================================
# PHASE 2: Purge GNOME desktop and apps
# ============================================================
echo ""
echo "=== PHASE 2: Purge GNOME desktop & apps ==="
sudo apt purge -y --autoremove \
  task-gnome-desktop gnome-core gnome-shell gnome-session \
  gnome-control-center gnome-terminal gnome-terminal-data \
  nautilus nautilus-data nautilus-extension-gnome-terminal \
  gnome-software gnome-software-common gnome-software-plugin-deb \
  gnome-software-plugin-fwupd gnome-text-editor gnome-maps \
  gnome-weather gnome-contacts gnome-clocks gnome-characters \
  gnome-connections gnome-music gnome-sound-recorder \
  gnome-calendar gnome-font-viewer gnome-tour gnome-user-docs \
  gnome-initial-setup gnome-sushi gnome-browser-connector \
  gnome-remote-desktop gnome-tweaks gnome-snapshot gnome-logs \
  gnome-system-monitor gnome-disk-utility gnome-menus \
  gnome-backgrounds gnome-bluetooth-sendto gnome-calculator \
  gnome-user-share gnome-online-accounts \
  task-hebrew-gnome-desktop task-japanese-gnome-desktop \
  task-korean-gnome-desktop task-malayalam-gnome-desktop \
  task-tamil-gnome-desktop task-telugu-gnome-desktop \
  task-thai-gnome-desktop 2>/dev/null || true

# ============================================================
# PHASE 3: Purge Evolution (email suite)
# ============================================================
echo ""
echo "=== PHASE 3: Purge Evolution ==="
sudo apt purge -y --autoremove \
  evolution evolution-common evolution-data-server \
  evolution-data-server-common evolution-ews evolution-ews-core \
  evolution-plugin-bogofilter evolution-plugin-pstimport \
  evolution-plugins libevolution libcamel-1.2-64t64 \
  libebackend-1.2-11t64 libebook-1.2-21t64 libebook-contacts-1.2-4t64 \
  libecal-2.0-3 libedata-book-1.2-27t64 libedata-cal-2.0-2t64 \
  libedataserver-1.2-27t64 libedataserverui-1.2-4t64 \
  libedataserverui4-1.0-0t64 libfolks-eds26 2>/dev/null || true

# ============================================================
# PHASE 4: Purge LibreOffice, Totem, GIMP help
# ============================================================
echo ""
echo "=== PHASE 4: Purge LibreOffice, Totem, GIMP help ==="
sudo apt purge -y --autoremove \
  libreoffice-core libreoffice-common libreoffice-help-ca \
  totem totem-common totem-plugins gir1.2-totem-1.0 \
  libtotem0 libtotem-plparser18 libtotem-plparser-common \
  gimp-help-sv 2>/dev/null || true

# ============================================================
# PHASE 5: Purge useless firmware (keep iwlwifi for Intel WiFi)
# ============================================================
echo ""
echo "=== PHASE 5: Purge unnecessary firmware ==="
sudo apt purge -y --autoremove \
  firmware-netronome firmware-atheros firmware-amd-graphics \
  firmware-nvidia-graphics firmware-marvell-prestera \
  firmware-mediatek firmware-bnx2 firmware-bnx2x \
  firmware-qlogic firmware-realtek firmware-samsung \
  firmware-siano 2>/dev/null || true

# ============================================================
# PHASE 6: Purge compilers and dev tools
# ============================================================
echo ""
echo "=== PHASE 6: Purge compilers ==="
sudo apt purge -y --autoremove \
  gcc-14-x86-64-linux-gnu gcc-14 g++-14-x86-64-linux-gnu \
  cpp-14-x86-64-linux-gnu 2>/dev/null || true

# ============================================================
# PHASE 7: Purge large font packs (keep basic fonts)
# ============================================================
echo ""
echo "=== PHASE 7: Purge large font packs ==="
sudo apt purge -y --autoremove \
  fonts-noto-extra fonts-noto-cjk-extra fonts-noto-ui-extra \
  fonts-noto-cjk 2>/dev/null || true

# ============================================================
# PHASE 8: Purge locales-all and unused locale data
# ============================================================
echo ""
echo "=== PHASE 8: Purge locales ==="
sudo apt purge -y --autoremove locales-all 2>/dev/null || true
echo "en_US.UTF-8 UTF-8" | sudo tee /etc/locale.gen
sudo locale-gen

# ============================================================
# PHASE 9: Purge unused dictionaries
# ============================================================
echo ""
echo "=== PHASE 9: Purge dictionaries ==="
sudo apt purge -y --autoremove \
  wpolish aspell-no aspell-sv aspell-de aspell-fr aspell-it \
  aspell-es aspell-pt aspell-ru aspell-ar aspell-ar-large \
  aspell-bg aspell-bn aspell-ca aspell-cs aspell-cy aspell-da \
  aspell-el aspell-eo aspell-et aspell-eu-es aspell-fa \
  aspell-fo aspell-ga aspell-gl-minimos aspell-gu \
  aspell-he aspell-hi aspell-hr aspell-hu aspell-hy \
  aspell-id aspell-is aspell-kk aspell-kn aspell-ku \
  aspell-lt aspell-lv aspell-ml aspell-mr aspell-nl \
  aspell-or aspell-pa aspell-pl aspell-ro aspell-sk \
  aspell-sl aspell-ta aspell-te aspell-tl aspell-uk \
  aspell-uz anthy anthy-common 2>/dev/null || true

echo ""
echo "=== PHASE 9b: Clean apt cache ==="
sudo apt clean

# ============================================================
# PHASE 10: Install LXQt (lightweight desktop)
# ============================================================
echo ""
echo "=== PHASE 10: Install LXQt ==="
sudo apt update
sudo apt install -y --no-install-recommends \
  lxqt-core \
  lxqt-panel \
  lxqt-session \
  lxqt-config \
  lxqt-qtplugin \
  lxqt-themes \
  lxqt-about \
  lxqt-admin \
  lxqt-globalkeys \
  lxqt-notificationd \
  lxqt-openssh-askpass \
  lxqt-policykit \
  lxqt-powermanagement \
  lxqt-runner \
  pcmanfm-qt \
  qterminal \
  pavucontrol-qt \
  openbox \
  sddm \
  sddm-theme-breeze \
  breeze-cursor-theme \
  tango-icon-theme \
  xdg-utils \
  xserver-xorg-input-synaptics \
  network-manager-gnome \
  gvfs gvfs-backends gvfs-fuse \
  gnome-keyring libpam-gnome-keyring \
  firefox-esr \
  vlc mpv \
  featherpad \
  qlipper \
  xclip

# Enable gnome-keyring SSH agent under LXQt.
# The default autostart file restricts to GNOME/Unity/MATE only.
# We copy it to the user's autostart dir and remove the restriction
# so gnome-keyring manages SSH keys (with passphrase caching) instead
# of the plain ssh-agent that Xsession would otherwise launch.
mkdir -p /home/$USERNAME/.config/autostart
cp /etc/xdg/autostart/gnome-keyring-ssh.desktop /home/$USERNAME/.config/autostart/
sed -i '/^OnlyShowIn=/d' /home/$USERNAME/.config/autostart/gnome-keyring-ssh.desktop
chown $USERNAME:$USERNAME /home/$USERNAME/.config/autostart/gnome-keyring-ssh.desktop

# Point SSH_AUTH_SOCK at gnome-keyring's ssh socket for X sessions.
# The autostart entry above starts the ssh component, but LXQt does not
# import the socket path into the session environment. As a result ssh
# still falls back to the plain ssh-agent started by Xsession, which
# does not cache passphrases. Setting the variable in ~/.xsessionrc
# (sourced before the Xsession ssh-agent script) fixes that.
cat > /home/$USERNAME/.xsessionrc <<'EOF'
# Use gnome-keyring's SSH agent instead of the plain ssh-agent that
# Xsession would otherwise launch. gnome-keyring caches SSH key
# passphrases, so ssh/git only prompt once per session.
export SSH_AUTH_SOCK="/run/user/$(id -u)/keyring/ssh"
EOF
chown $USERNAME:$USERNAME /home/$USERNAME/.xsessionrc

# ============================================================
# PHASE 11: Install and configure SSH server
# ============================================================
echo ""
echo "=== PHASE 11: Install SSH server ==="
sudo apt install -y openssh-server

# Restrict SSH to local network only.
# We use two methods: sshd_config Match Address AND firewall rules.
echo ""
echo "--- Configuring SSH for local network only ---"

# Backup original sshd_config if not already backed up
if [ ! -f /etc/ssh/sshd_config.orig ]; then
  sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.orig
fi

# Add a Match block at the end of sshd_config to restrict access.
# Only connections from the local subnet are allowed.
if ! grep -q "Match Address" /etc/ssh/sshd_config; then
  echo "" | sudo tee -a /etc/ssh/sshd_config
  echo "# Restrict SSH to local network (added by bootstrap.sh)" | sudo tee -a /etc/ssh/sshd_config
  echo "Match Address $SSH_ALLOW_NET" | sudo tee -a /etc/ssh/sshd_config
  echo "    AllowUsers $USERNAME" | sudo tee -a /etc/ssh/sshd_config
  echo "Match All" | sudo tee -a /etc/ssh/sshd_config
fi

sudo systemctl enable ssh
sudo systemctl restart ssh

# ============================================================
# PHASE 12: Configure firewall (UFW)
# ============================================================
echo ""
echo "=== PHASE 12: Configure firewall ==="
sudo apt install -y ufw

# Default deny incoming, allow outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH only from local network
sudo ufw allow from $SSH_ALLOW_NET to any port 22 proto tcp

# Enable firewall (skip if already enabled)
sudo ufw --force enable

# ============================================================
# PHASE 13: Set up external media drive mount point
# ============================================================
echo ""
echo "=== PHASE 13: Set up media mount point ==="
sudo mkdir -p "$MEDIA_MOUNT"
sudo chown "$USERNAME:$USERNAME" "$MEDIA_MOUNT"

echo ""
echo "--- IMPORTANT: USB drive not automatically configured ---"
echo "After connecting your external USB drive, find its UUID with:"
echo "    lsblk -f"
echo "Then add an entry to /etc/fstab like:"
echo "    UUID=your-uuid-here $MEDIA_MOUNT ext4 defaults,noatime 0 2"
echo "Then mount with:"
echo "    sudo mount $MEDIA_MOUNT"

# ============================================================
# PHASE 14: Final cleanup
# ============================================================
echo ""
echo "=== PHASE 14: Final cleanup ==="
sudo apt autoremove --purge -y
sudo apt clean

# ============================================================
# DONE
# ============================================================
echo ""
echo "============================================================"
echo " BOOTSTRAP COMPLETE"
echo "============================================================"
df -h /
echo ""
echo "Next steps:"
echo "  1. Set a static IP for this machine on your router"
echo "     (find the MAC address with: ip link show wlan0)"
echo "  2. Connect your USB media drive and configure /etc/fstab"
echo "     (see instructions in Phase 13 above)"
echo "  3. Reboot and choose LXQt from the SDDM session menu"
echo "     sudo reboot"
echo ""
echo "The machine will be reachable via SSH on the local network:"
echo "  ssh $USERNAME@<static-ip>"
echo "============================================================"