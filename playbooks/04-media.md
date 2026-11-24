# Playbook 04: Media

Goal: play local video and audio from an external USB drive using VA-API
hardware video decode, with sound routed to the TV (HDMI) or the stereo
(headphone jack).

## Current State

- VLC 3.0.24 and mpv 0.40.0 are installed.
- VA-API is available via the Intel i965 driver. Hardware decode works
  for H.264 (all profiles), HEVC Main, MPEG-2, VC-1, VP8, and JPEG.
  There is no VP9 and no HEVC Main10 decode.
- /mnt/media does not exist yet. No external USB drive is configured.
- PipeWire is the sound server. Card 0 is HDMI audio (to the TV). Card 1
  is the chtrt5650 codec (headphone jack to the stereo).

## Steps

1. Create the media mount point.

   Reference:

       sudo mkdir -p /mnt/media
       sudo chown mjeffe:mjeffe /mnt/media

2. Mount the external USB drive.

   This step is per-drive and manual. Connect the drive, find its UUID,
   and add an fstab entry. Reference:

       lsblk -f

       UUID=<your-drive-uuid> /mnt/media ext4 defaults,noatime 0 2

   Then:

       sudo systemctl daemon-reload
       sudo mount /mnt/media

   Use the UUID, not a device path like /dev/sdb1, because device names
   can change between boots.

3. Enable VA-API in mpv.

   Reference, for a one-off test:

       mpv --hwdec=vaapi /mnt/media/movie.mkv

   For a persistent default, create ~/.config/mpv/mpv.conf with:

       hwdec=vaapi

4. Route audio.

   - Movies on the TV: video over HDMI, audio on card 0 (HDMI).
   - Music on the stereo: audio on card 1 (chtrt5650, headphone jack).

   Use pavucontrol-qt (LXQt volume control) to pick the output per app.
   PipeWire keeps the routing simple.

## Verify

- lsblk shows the USB drive mounted at /mnt/media.
- vainfo lists H264 profiles and HEVCMain, and does not list VP9.
- mpv --hwdec=vaapi plays a 1080p H.264 file with low CPU use.
- Sound comes out of the correct output for movies and music.

## Gotchas

- 10-bit HEVC (Main10) and VP9 will software-decode and are too slow for
  1080p on this CPU. Prefer H.264 or 8-bit HEVC Main files.
- Media files live on the external USB drive, never on the eMMC.
- The chtrt5650 audio codec is finicky on Chromebooks. If the headphone
  output is silent, it may need UCM or kernel quirk tweaks.
- If the USB drive is not present at boot, the fstab entry should not
  hang the boot. Consider the nofail option for removable media.
