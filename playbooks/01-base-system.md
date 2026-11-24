# Playbook 01: Base System

Goal: a minimal Debian 13 base system on the internal eMMC, with the
right hostname, user, locale, timezone, and apt sources for firmware.

## Current State

- Installed from the Debian 13.7.0 live GNOME image.
- Hostname: mediaman. User: mjeffe (has sudo).
- Locale: en_US.UTF-8. Timezone: America/Chicago.
- Disk layout: EFI partition, ext4 root, and swap on the internal eMMC.
  No external media drive is configured yet (see 04-media.md).
- apt sources: the active lines are main only. The live installer left
  non-free-firmware on the install media but not in the active sources.
- intel-microcode and firmware-iwlwifi are already installed.

## Steps

1. Enable non-free-firmware in the apt sources so firmware gets updates.

   Reference: edit /etc/apt/sources.list so each deb line reads:

       deb http://deb.debian.org/debian/ trixie main non-free-firmware
       deb http://security.debian.org/debian-security trixie-security main non-free-firmware
       deb http://deb.debian.org/debian/ trixie-updates main non-free-firmware

   Then run:

       sudo apt update

   Add contrib only if a specific package requires it. This machine does
   not need it today.

2. Confirm the firmware packages are present.

   Reference:

       sudo apt install -y intel-microcode firmware-iwlwifi

   intel-microcode provides CPU security updates. firmware-iwlwifi
   provides the Intel 7265 WiFi firmware. Both should already be
   installed from the live image.

3. Confirm hostname, locale, and timezone.

   Reference:

       sudo hostnamectl set-hostname mediaman
       sudo timedatectl set-timezone America/Chicago
       sudo localectl set-locale LANG=en_US.UTF-8

## Verify

- apt update completes without errors.
- df -h / shows the root partition with room to spare.
- hostnamectl shows Static hostname: mediaman.
- locale shows LANG=en_US.UTF-8.
- timedatectl shows Time zone: America/Chicago.

## Gotchas

- This playbook assumes a bootable Debian install already exists. The
  Chromebook firmware unlock that precedes the install is out of scope.
- Keep deb-src lines only if you plan to build packages. They are
  harmless but unnecessary here.
- Do not expand the partition layout. The eMMC is 14.7GB total and the
  current layout is already the intended one.
