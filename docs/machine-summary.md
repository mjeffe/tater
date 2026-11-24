# Machine Summary: ASUS Chromebook "Kefka" (Media Center)

**Written**: 2026-11-23 | **Hostname**: mediaman | **Current OS**: Debian 13 "Trixie"

---

## Hardware Profile

| Component | Detail |
|-----------|--------|
| **Platform** | Google "Kefka" reference board, Intel "Strago" family |
| **CPU** | Intel Celeron N3060 (Braswell/Cherry Trail) |
| | 2 cores / 2 threads (no HT), 1.60GHz base, ~2.48GHz burst |
| | 1MB L2 cache, 14nm, 6W TDP (fanless/passive cooling design) |
| **RAM** | 4GB DDR3L-1600 (soldered, non-upgradeable) |
| **Storage** | 14.7GB eMMC (soldered, non-replaceable) |
| | Currently 7.0G used / 5.2G available on / (58%) |
| **GPU** | Intel HD Graphics 400 (Braswell), integrated |
| | OpenGL 4.6, OpenGL ES 3.2 |
| | VA-API hardware decode: H.264 (all profiles), H.265/HEVC Main, MPEG-2, VC-1, VP8, JPEG |
| | **No VP9 or H.265 Main10 hardware decode** (Cherry Trail limitation) |
| | 768MB shared video memory |
| **Display** | Internal 1366x768 eDP panel |
| **Audio** | Intel HDA: 3x HDMI audio outputs (to TV via HDMI) |
| | Realtek RT5650 codec ("chtrt5650"): headphone jack + mic |
| **WiFi** | Intel Wireless 7265 (Dual Band 802.11ac) |
| **Bluetooth** | Intel Bluetooth 4.x (USB-attached) |
| **USB** | xHCI host controller (USB 3.0 support) |
| **Battery** | Single internal battery |
| **Input** | Logitech Unifying Receiver (wireless keyboard/mouse) |

---

## Current Software Stack

- **OS**: Debian 13 Trixie (x86_64), kernel 6.12.107+deb13-amd64
- **Desktop**: LXQt 2.1 on Openbox 3.6 (X11)
- **Display manager**: SDDM
- **Sound**: PipeWire (default)
- **GPU driver**: i915 + Mesa 25.0.7 (Intel i965 VA-API driver)

---

## Audio Hardware Layout

```
card 0: PCH [HDA Intel PCH]
  device 3 -> HDMI 0
  device 7 -> HDMI 1
  device 8 -> HDMI 2
card 1: chtrt5650 [chtrt5650]  <- headphone/mic jack
  device 0 -> Stereo playback (headphone jack)
  device 1 -> Mono? (likely mic input or alt output)
```

Use case mapping:
- **Movies on TV**: video over HDMI + audio over card 0 (HDMI) 
- **Music on stereo**: audio over card 1 (chtrt5650, headphone jack -> 3.5mm -> RCA/stereo input)

---

## Notes for Future Agents

1. **Storage is EXTREMELY tight** (14.7GB total). Any media files MUST live on external USB drives. Keep the internal eMMC lean: OS + apps only.
2. **CPU is very weak** (dual-core Atom-era Celeron). Offload video decode to VA-API hardware whenever possible (`--vo=gpu --hwdec=vaapi` in mpv). Software decoding of 1080p H.264 may be borderline.
3. **H.265/HEVC hardware decode is limited** to Main profile only, not Main10. 10-bit HEVC will be software-decoded (likely too slow for 1080p on this CPU).
4. **The chtrt5650 audio codec** is notorious on Chromebooks. It may need specific UCM (Use Case Manager) configs or kernel quirk tweaks for reliable headphone output.
5. **WiFi is solid** (Intel 7265 AC): good driver (iwlwifi), no known issues.
6. **This is an EOL Chromebook**: no more ChromeOS updates. Linux is the right move.