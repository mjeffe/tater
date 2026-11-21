# Roadmap

Ideas and experiments for the media center, roughly ordered by priority.

## Near Term

- [ ] **Static IP**: Configure the router to assign a sticky/reserved IP to
  the Chromebook's MAC address. This keeps SSH access predictable.
- [ ] **USB drive setup**: Format the 1TB external drive as ext4, mount it at
  `/mnt/media` via `/etc/fstab` (by UUID).
- [ ] **Streaming services**: Test Netflix, Hulu, and YouTube playback in
  Firefox ESR. If resolution is capped, test Chrome or Chromium as an
  alternative.
- [ ] **Audio routing**: Verify HDMI audio (movies) and headphone jack audio
  (music) both work. Configure PipeWire to make switching easy.

## Future Experiments

- [ ] **VLC remote control**: VLC has a built-in HTTP interface and mobile
  remote apps. Enable it for phone-based playback control.
- [ ] **Kodi**: A more polished 10-foot media center interface. Evaluate the
  package size and whether the Celeron N3060 can run it smoothly. Kodi also
  has mobile remote apps.
- [ ] **Torrent client**: Lightweight daemon like Transmission for downloading
  media directly on the machine. Configure download path to the external USB
  drive.
- [ ] **Pi-hole**: Network-wide ad blocking. This machine is always on, making
  it a good Pi-hole candidate. Needs careful space planning (Pi-hole is small,
  but logs grow).
- [ ] **Bluetooth audio**: Test if the internal Bluetooth can pair with a
  speaker or the stereo as an alternative to the headphone jack cable.

## Maybe Someday

- [ ] **Jellyfin**: Self-hosted media server with a web UI and transcoding.
  The weak CPU means transcoding would be painful, but direct-play to a
  client device (phone, tablet, Chromecast) could work well.
- [ ] **External DVD/Blu-ray drive**: Play physical discs via a USB optical
  drive.
- [ ] **VPN**: Route traffic through a VPN for privacy when torrenting.
- [ ] **Automated media organization**: Tools like FileBot or Sonarr/Radarr
  for renaming and organizing downloaded media.