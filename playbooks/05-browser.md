# Playbook 05: Browser

Goal: a usable web browser on the N3060. Firefox ESR is installed and
configured so the weak CPU is not wasted on ads, trackers, and software
video decode.

## Current State

- Firefox ESR 153.7.0 from the Debian package firefox-esr.
- Compositing uses WebRender.
- VA-API is available (Intel i965 driver) for H.264 and HEVC Main decode.
- Two Firefox extensions are installed by hand: uBlock Origin and
  enhanced-h264ify. These are user-level, not package-level, and must be
  re-added by hand or restored from a Firefox profile.

## Why This Matters

- The N3060 is very weak. Ad and tracking scripts are the heaviest
  JavaScript a page runs. Blocking them is the single biggest speed win.
- The GPU cannot hardware-decode VP9 or AV1. YouTube serves those by
  default, so video falls back to software decode and the CPU pegs.
  Forcing H.264 lets the GPU do the work.

## Steps

1. Install Firefox ESR. bootstrap.sh already does this; the line is kept
   here for completeness.

   Reference:
       sudo apt install -y firefox-esr

2. Install uBlock Origin from addons.mozilla.org.
   - Search for "uBlock Origin" and install the one by Raymond Hill.
   - Do not install the fork called "uBlock" with no Origin. It is
     abandoned.

3. Install enhanced-h264ify from addons.mozilla.org.
   - Open its options and block VP9 and AV1.
   - Leave H.264 allowed.
   - This affects YouTube only.

4. Confirm hardware video decode is available.

   Reference:
       vainfo

   - Expect H264 profiles and HEVCMain in the output.
   - Expect no VP9 and no HEVCMain10. That is correct for this GPU.

5. Confirm Firefox compositing.

   Reference:
       about:support

   - The Compositing row should say WebRender.

6. If video still pegs the CPU after the extensions, check the VA-API
   preference in about:config.

       media.ffmpeg.vaapi.enabled = true

## Verify

- Load a heavy news site with uBlock Origin on and off. CPU use should
  drop noticeably with it on.
- Play a 1080p YouTube video with enhanced-h264ify forcing H.264. CPU use
  should stay low because the GPU is decoding.
- vainfo lists H264 profiles and HEVCMain, and does not list VP9.

## Gotchas

- The two extensions are the only browser configuration that is not
  captured by a Debian package. On a fresh machine they must be
  reinstalled, or the Firefox profile restored from backup.
- Firefox ESR lags the regular release on web features. A few sites or
  extensions may want a newer Firefox. Prefer keeping firefox-esr unless
  something actually breaks.
