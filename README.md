# tater: A couch potato's minimalist media center

A repurposed ASUS Chromebook "Kefka" running Debian 13, connected to the
living room TV via HDMI. It plays movies and music from a USB drive, streams
online services, and serves as a general family media hub.

## Hardware at a Glance

- **Machine**: ASUS Chromebook "Kefka" (Google reference board, Intel Strago family)
- **CPU**: Intel Celeron N3060, 2 cores, 1.60GHz (fanless, 6W TDP)
- **RAM**: 4GB DDR3L (soldered, not upgradeable)
- **Storage**: 14.7GB internal eMMC (OS + apps only, no media)
- **GPU**: Intel HD Graphics 400 with VA-API hardware video decode
- **Display**: 1366x768 internal panel + HDMI output to TV
- **Audio**: HDMI audio to TV, headphone jack to stereo for music
- **Network**: Intel Wireless 7265 (802.11ac)

Full hardware details: see `docs/machine-summary.md`.

## Goals

1. **Local media playback**: Movies and TV shows played from an external USB
   hard drive via VLC or mpv, with hardware-accelerated video decode.
2. **Music playback**: Audio through the headphone jack to an external stereo
   system.
3. **Online streaming**: Netflix, Hulu, YouTube, and other services through a
   web browser (Firefox ESR or Chrome).
4. **Remote control**: SSH access from the local network for maintenance and
   file management.
5. **Keep the internal drive lean**: All media lives on external USB storage.
   The internal eMMC is reserved for the OS and essential applications.

## Current Setup

- **OS**: Debian 13 "Trixie" (x86_64)
- **Desktop**: LXQt on Openbox (lightweight, replaced GNOME)
- **Display manager**: SDDM
- **Media players**: VLC, mpv
- **Browser**: Firefox ESR
- **Sound**: PipeWire
- **SSH**: OpenSSH server, restricted to local network

## Directory Structure

```
~/src/tater/
  README.md               This file
  AGENTS.md               Rules and context for AI coding agents
  docs/
    roadmap.md            Future plans and experiments
    machine-summary.md    Detailed hardware and software profile
  scripts/
    bootstrap.sh          Master script: fresh Debian install to media center
    cleanup-and-install-lxqt.sh  Purge GNOME, install LXQt (first run)
```

## Daily Use

- Use the wireless keyboard and mouse (Logitech Unifying Receiver) for
  normal interaction.
- SSH in from another machine on the local network for file transfers or
  remote maintenance.
- Media files are stored on an external USB drive mounted at `/mnt/media`.
- To play a video: open VLC or mpv, browse to `/mnt/media/`, and play.
- For streaming services: open Firefox and navigate to the service.

## Quick Reference: Common Tasks

```sh
# Check disk space (always be mindful of the 14.7GB limit)
df -h /

# Mount the media drive (if not auto-mounted)
sudo mount /mnt/media

# Check what is using space
du -sh /home/*/
```