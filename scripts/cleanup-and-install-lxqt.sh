#!/bin/bash
# ============================================================
# Media Center Cleanup + LXQt Install
# For ASUS Chromebook "Kefka" / Debian 13
# Run as: bash cleanup-and-install-lxqt.sh
# ============================================================
set -e

echo "=== PHASE 1: Purge GNOME desktop & apps ==="
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
  task-thai-gnome-desktop

echo ""
echo "=== PHASE 2: Purge Evolution (email suite) ==="
sudo apt purge -y --autoremove \
  evolution evolution-common evolution-data-server \
  evolution-data-server-common evolution-ews evolution-ews-core \
  evolution-plugin-bogofilter evolution-plugin-pstimport \
  evolution-plugins libevolution libcamel-1.2-64t64 \
  libebackend-1.2-11t64 libebook-1.2-21t64 libebook-contacts-1.2-4t64 \
  libecal-2.0-3 libedata-book-1.2-27t64 libedata-cal-2.0-2t64 \
  libedataserver-1.2-27t64 libedataserverui-1.2-4t64 \
  libedataserverui4-1.0-0t64 libfolks-eds26

echo ""
echo "=== PHASE 3: Purge LibreOffice, Totem, GIMP help ==="
sudo apt purge -y --autoremove \
  libreoffice-core libreoffice-common libreoffice-help-ca \
  totem totem-common totem-plugins gir1.2-totem-1.0 \
  libtotem0 libtotem-plparser18 libtotem-plparser-common \
  gimp-help-sv

echo ""
echo "=== PHASE 4: Purge useless firmware (this is an Intel machine) ==="
sudo apt purge -y --autoremove \
  firmware-netronome firmware-atheros firmware-amd-graphics \
  firmware-nvidia-graphics firmware-marvell-prestera \
  firmware-mediatek firmware-bnx2 firmware-bnx2x \
  firmware-qlogic firmware-realtek firmware-samsung \
  firmware-siano 2>/dev/null || true
# NOTE: firmware-iwlwifi is KEPT (Intel WiFi)

echo ""
echo "=== PHASE 5: Purge compilers and dev tools ==="
sudo apt purge -y --autoremove \
  gcc-14-x86-64-linux-gnu gcc-14 g++-14-x86-64-linux-gnu \
  cpp-14-x86-64-linux-gnu 2>/dev/null || true

echo ""
echo "=== PHASE 6: Purge massive font packs (keep basic fonts) ==="
sudo apt purge -y --autoremove \
  fonts-noto-extra fonts-noto-cjk-extra fonts-noto-ui-extra \
  fonts-noto-cjk

echo ""
echo "=== PHASE 7: Purge locales-all and unnecessary locale data ==="
sudo apt purge -y --autoremove locales-all
# Then configure just the locales we need
echo "en_US.UTF-8 UTF-8" | sudo tee /etc/locale.gen
sudo locale-gen

echo ""
echo "=== PHASE 8: Purge dictionaries and languages we don't need ==="
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
echo "=== PHASE 9: Clean apt cache ==="
sudo apt clean

echo ""
echo "=== PHASE 10: Install LXQt (lightweight desktop) ==="
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
  qlipper

echo ""
echo "=== PHASE 11: Final cleanup ==="
sudo apt autoremove --purge -y
sudo apt clean

echo ""
echo "============================================================"
echo " DONE! Check disk space:"
df -h /
echo ""
echo " NEXT: sudo reboot (choose LXQt from SDDM session menu)"
echo "============================================================"