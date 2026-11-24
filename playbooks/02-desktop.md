# Playbook 02: Desktop

Goal: a lightweight LXQt desktop on Openbox with SDDM as the display
manager, and no GNOME left behind.

## Current State

- LXQt 2.1 on Openbox 3.6.1, running under X11.
- Display manager: SDDM.
- GNOME and the other desktop bloat were purged during initial setup.

## Why

- The N3060 has 4GB RAM and a 14.7GB eMMC. GNOME is heavy in both
  memory and disk. LXQt on Openbox is far lighter and is the right fit.

## Steps

1. Purge GNOME and friends.

   Intent: remove GNOME Shell, the GNOME apps, Evolution (email suite),
   LibreOffice, Totem, and large font packs, locales, and dictionaries
   that are not used.

   The exact package list for Trixie lives in scripts/bootstrap.sh phases
   2 through 9. It is the known-good reference. Treat those package names
   as illustrative: the t64 library suffixes and the gcc-14 versioned
   names are Trixie-specific and will change on the next release.

   An agent should:
   - confirm each package exists before purging it, or
   - use apt-cache depends / dpkg-query to derive current names.

   Important: keep firmware-iwlwifi (Intel WiFi). Do not purge it.

2. Install LXQt and the essentials.

   Reference (no-install-recommends keeps it lean):

       sudo apt install -y --no-install-recommends \
         lxqt-core lxqt-panel lxqt-session lxqt-config lxqt-qtplugin \
         lxqt-themes lxqt-about lxqt-admin lxqt-globalkeys \
         lxqt-notificationd lxqt-openssh-askpass lxqt-policykit \
         lxqt-powermanagement lxqt-runner pcmanfm-qt qterminal \
         pavucontrol-qt openbox sddm sddm-theme-breeze \
         breeze-cursor-theme tango-icon-theme xdg-utils \
         xserver-xorg-input-synaptics network-manager-gnome \
         gvfs gvfs-backends gvfs-fuse gnome-keyring libpam-gnome-keyring \
         firefox-esr vlc mpv featherpad qlipper xclip

3. Make SDDM the display manager.

   Reference:

       sudo systemctl enable sddm

## Desired State

- Package gnome-shell: not installed.
- Packages lxqt-core, openbox, sddm: installed.
- Service sddm: enabled.
  Check: systemctl is-enabled sddm
- Session: LXQt on X11.
  Check: echo $XDG_CURRENT_DESKTOP $XDG_SESSION_TYPE
- Package firmware-iwlwifi: installed (it must survive the purge).
- Root filesystem: under 60 percent used.
  Check: df -h /

## Gotchas

- Do not purge firmware-iwlwifi. It is the WiFi firmware.
- The purge list in bootstrap.sh is Trixie-specific. Names like
  libcamel-1.2-64t64 and gcc-14 will change.
- network-manager-gnome provides the system tray WiFi applet under LXQt.
  Keep it even though it has gnome in the name.
- Firefox, VLC, and mpv are installed here because they are core to the
  media center role.
