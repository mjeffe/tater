# Playbooks

Agent-executable setup instructions for the tater media center.

These playbooks describe the target state of the machine as it is today.
They are meant to be read and executed by an AI coding agent, not run as
shell scripts. Each playbook states a goal, the constraints that matter,
reference commands, and how to verify the result.

## How To Use

- Read this file first. It holds the global constraints and the reading
  order.
- Work through the playbooks in numeric order on a fresh machine.
- Reference commands are known-good but illustrative. Package names and
  versions change between Debian releases, so an agent should confirm
  current names with apt or dpkg before installing or purging.
- Do not add branching or alternatives inside a playbook. A playbook
  describes one target state. Future ideas and alternatives belong in
  docs/roadmap.md.
- When the machine changes, update the relevant playbook in the same
  commit as the change. The playbooks should always match reality.

## Global Constraints

These apply to every playbook. Re-read them before each step.

- Storage: 14.7GB internal eMMC, about 5GB free. Check `df -h /` before
  installing anything. Media files live on external USB, never on the
  internal drive.
- CPU: Intel Celeron N3060, 2 cores, 1.60GHz. Offload video to VA-API
  hardware decode whenever possible.
- RAM: 4GB soldered. Avoid memory-heavy daemons.
- GPU decode: H.264 (all profiles) and H.265/HEVC Main only. No VP9, no
  H.265 Main10. Those software-decode and are too slow for 1080p.
- Network: local network only. No internet-facing SSH or services.

## Machine Identity

- Hostname: mediaman
- User: mjeffe
- OS: Debian 13 "Trixie", x86_64
- Desktop: LXQt on Openbox
- Display manager: SDDM

## Reading Order

Only 00-index.md and 05-browser.md exist so far. The rest are planned.

- 00-index.md - this file
- 01-base-system.md - fresh Debian install, user, locale, disk layout
- 02-desktop.md - purge GNOME, install LXQt on Openbox with SDDM
- 03-ssh-and-firewall.md - SSH restricted to local network, UFW
- 04-media.md - VLC, mpv, VA-API, USB media drive, audio routing
- 05-browser.md - Firefox ESR, ad blocking, hardware video decode
- 06-user-config.md - gnome-keyring, QTerminal shortcuts, daily-use details

## Relationship To scripts/

- scripts/ holds shell scripts that a human runs directly.
- scripts/bootstrap.sh is the current known-good end-to-end installer.
- playbooks/ are the source of truth for intent. If a script and a
  playbook disagree, trust the playbook and update the script.
- Keep scripts/ as a reference for a fresh install, per AGENTS.md.
