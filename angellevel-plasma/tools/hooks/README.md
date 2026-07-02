# Package-manager notifier hooks

The AngelLevel install script sets up a **systemd user timer** that runs
`angellevel-update-notifier` every 6 hours — that alone gives themed
"updates available" notifications with the AngelLevel icons.

To also fire *immediately after a transaction*, install the matching hook
(these are **system-wide** and need root):

- **Arch / pacman:** copy `50-angellevel-notify.hook` to `/etc/pacman.d/hooks/`.
- **Debian / apt:** copy `99angellevel-notify` to `/etc/apt/apt.conf.d/`.
- **Fedora / dnf:** enable `dnf-automatic` (`--downloadonly`) and add a
  `--setopt` post-hook, or add a drop-in that runs:
  `systemctl --user -M <user>@ start angellevel-update-notifier.service`.

Each hook just starts the user's `angellevel-update-notifier.service` for every
logged-in session, so the notification appears in that user's tray.
