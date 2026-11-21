# AGENTS.md

Rules and context for AI coding agents working on this project.

## Writing Rules

All documentation files (README.md, AGENTS.md, docs/roadmap.md,
docs/machine-summary.md, and any new docs) must follow these rules:

1. Write in plain ASCII only. No Unicode characters, no em-dashes, no smart
   quotes, no fancy punctuation. Use --- for separators, not box-drawing
   characters or fancy horizontal rules.
2. When you need to rephrase something, use simple sentence structures: two
   shorter sentences joined by a period, a colon, or a comma. Avoid complex
   nested clauses that require em-dashes or semicolons.
3. Bullet points use `-` (hyphen), not Unicode bullets.
4. Code blocks and shell commands are fine as-is (they are ASCII already).
5. File paths, hostnames, and technical identifiers stay exactly as written.

## Project Context

This is a home media center project running on a repurposed ASUS Chromebook
"Kefka" with Debian 13. The machine has extremely limited resources:

- **Storage**: 14.7GB internal eMMC total. Approximately 12GB used after OS
  and apps. Always check `df -h /` before installing anything. Large packages
  or caches can fill the disk immediately.
- **CPU**: Intel Celeron N3060, dual-core, 1.60GHz. Very weak. Offload video
  decoding to VA-API hardware acceleration whenever possible.
- **RAM**: 4GB DDR3L, soldered. Not upgradeable. Be mindful of memory-heavy
  applications.
- **GPU decode limits**: H.264 (all profiles), H.265/HEVC Main only. No VP9,
  no H.265 Main10 hardware decode. 10-bit HEVC and VP9 will software-decode,
  which is too slow for 1080p on this CPU.

Media files live on an external USB drive, never on the internal eMMC.

## When Writing Scripts

1. Every script in `scripts/` should be a reference for a fresh install.
   Imagine wiping the machine and starting from a stock Debian 13 image: the
   scripts should reproduce the current state.
2. Use `set -e` at the top of shell scripts.
3. Add comments explaining what each phase does and why.
4. Avoid interactive prompts. Use `-y` flags and set defaults explicitly.
5. Test for available disk space before downloading or installing large
   packages.

## When Making Changes

1. Check current disk usage first: `df -h /`.
2. If a change needs more than 500MB of new packages, flag it clearly and
   explain the benefit vs. the space cost.
3. Prefer removing unused packages over adding new ones when space is tight.
4. Document any system-level change in the commit message and update
   `docs/machine-summary.md` if hardware or OS configuration changes.

## Machine Identity

- Hostname: `mediaman`
- User: `mjeffe`
- OS: Debian 13 "Trixie", x86_64
- Desktop: LXQt on Openbox
- Display manager: SDDM
- Local network SSH only (no internet-facing SSH)