# Playbook 06: User Config

Goal: user-level conveniences that are not covered by packages or system
scripts: a working SSH agent, terminal tab switching on a keyboard with
no PgUp/PgDn keys, and daily-use notes.

## Current State

- gnome-keyring SSH agent is configured via an autostart entry and
  ~/.xsessionrc. It caches SSH key passphrases for the session.
- QTerminal tab switching is bound to Alt+1 through Alt+9, plus Alt+0
  for tab 10, because this keyboard has no PgUp/PgDn keys for the
  default Ctrl+PgUp / Ctrl+PgDn bindings.
- Input is a Logitech Unifying Receiver keyboard and mouse.

## Steps

1. gnome-keyring SSH agent.

   The LXQt autostart entry must be copied to the user's autostart dir
   with the GNOME-only restriction removed. Reference:

       mkdir -p ~/.config/autostart
       cp /etc/xdg/autostart/gnome-keyring-ssh.desktop ~/.config/autostart/
       sed -i '/^OnlyShowIn=/d' ~/.config/autostart/gnome-keyring-ssh.desktop

   Then point SSH_AUTH_SOCK at the keyring socket for X sessions, in
   ~/.xsessionrc:

       export SSH_AUTH_SOCK="/run/user/$(id -u)/keyring/ssh"

   This is already in place on the current machine.

2. QTerminal tab shortcuts.

   QTerminal reads its config from ~/.config/qterminal.org/qterminal.ini.
   Under [Shortcuts], bind the tab actions:

       Tab 1  = Alt+1
       Tab 2  = Alt+2
       ...
       Tab 9  = Alt+9
       Tab 10 = Alt+0

   The keys are URL-encoded in the file, so Tab 1 is Tab%201 and Tab 10
   is Tab%2010. Restart QTerminal after editing.

3. Daily use.

   - The Logitech receiver drives the keyboard and mouse.
   - SSH in from another LAN machine for file transfers and maintenance.
   - Media lives at /mnt/media on the external USB drive.

## Desired State

- File ~/.config/autostart/gnome-keyring-ssh.desktop: exists, with no
  OnlyShowIn line.
  Check: grep -c OnlyShowIn ~/.config/autostart/gnome-keyring-ssh.desktop
- File ~/.xsessionrc: exports SSH_AUTH_SOCK pointing at the keyring
  socket.
  Check: cat ~/.xsessionrc
- QTerminal shortcuts: Tab 1 through Tab 9 bound to Alt+1 through Alt+9,
  and Tab 10 bound to Alt+0.
  Check: grep -E 'Tab%20[0-9]+' ~/.config/qterminal.org/qterminal.ini
- ssh-add -l lists loaded keys after a session restart.
- Alt+number switches QTerminal tabs.

## Gotchas

- Binding Alt+number in QTerminal means those keys no longer reach the
  shell. Apps that use Alt+number internally (screen, weechat, irssi)
  will not see them.
- QTerminal only reads the config at startup. Restart it after changes.
- gnome-keyring caches passphrases per session. After a reboot you will
  be prompted again, which is the intended behavior.
