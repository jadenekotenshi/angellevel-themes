#!/usr/bin/env bash
#
# Installs the AngelLevel Plasma theme bundle into the current user's
# ~/.local/share tree. Re-run safely; it overwrites previous copies.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

echo "Installing AngelLevel Plasma theme from: $SRC"
echo "Target data dir: $DATA"

# 1. Color scheme
install -d "$DATA/color-schemes"
install -m 644 "$SRC/color-schemes/AngelLevel.colors" "$DATA/color-schemes/AngelLevel.colors"
echo "  - color scheme  -> $DATA/color-schemes/AngelLevel.colors"

# 2. Aurorae window decoration
install -d "$DATA/aurorae/themes/AngelLevel"
install -m 644 "$SRC/aurorae/AngelLevel/"* "$DATA/aurorae/themes/AngelLevel/"
echo "  - window decor  -> $DATA/aurorae/themes/AngelLevel/"

# 3. Konsole color scheme
install -d "$DATA/konsole"
install -m 644 "$SRC/konsole/AngelLevel.colorscheme" "$DATA/konsole/AngelLevel.colorscheme"
echo "  - konsole       -> $DATA/konsole/AngelLevel.colorscheme"

# 4. Icon theme (cp -R preserves the alias symlinks inside the tree)
install -d "$DATA/icons"
rm -rf "$DATA/icons/AngelLevel"
cp -R "$SRC/icons/AngelLevel" "$DATA/icons/AngelLevel"
echo "  - icon theme    -> $DATA/icons/AngelLevel/"
# Refresh the icon cache if the tool is present (not required by KDE).
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -f -t "$DATA/icons/AngelLevel" 2>/dev/null || true
fi

# 4b. Cursor theme (AngelLevel IRIX — shared, lives one level up in the repo)
CURSORS="$SRC/../angellevel-cursors/AngelLevel-IRIX"
if [ -d "$CURSORS" ]; then
  install -d "$DATA/icons"
  rm -rf "$DATA/icons/AngelLevel-IRIX"
  cp -R "$CURSORS" "$DATA/icons/AngelLevel-IRIX"
  echo "  - cursor theme  -> $DATA/icons/AngelLevel-IRIX/ (wired via Global Theme)"
else
  echo "  ! cursor theme not found at $CURSORS (skipped)"
fi

# 5. Plasma Style (desktop/widget theme)
install -d "$DATA/plasma/desktoptheme"
rm -rf "$DATA/plasma/desktoptheme/AngelLevel"
cp -R "$SRC/plasma/desktoptheme/AngelLevel" "$DATA/plasma/desktoptheme/AngelLevel"
echo "  - plasma style  -> $DATA/plasma/desktoptheme/AngelLevel/"

# 5b. Kvantum application style (the chiselled NeXT widget look; needs the
#     Kvantum engine installed for widgetStyle=kvantum to take effect).
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
if [ -d "$SRC/kvantum/AngelLevel" ]; then
  install -d "$CFG/Kvantum/AngelLevel"
  install -m 644 "$SRC/kvantum/AngelLevel/"* "$CFG/Kvantum/AngelLevel/"
  # Select AngelLevel as the active Kvantum theme without clobbering an existing
  # config: prefer kvantummanager (preserves other keys), else only write fresh.
  if command -v kvantummanager >/dev/null 2>&1; then
    kvantummanager --set AngelLevel >/dev/null 2>&1 || true
  elif [ ! -f "$CFG/Kvantum/kvantum.kvconfig" ]; then
    printf '[General]\ntheme=AngelLevel\n' > "$CFG/Kvantum/kvantum.kvconfig"
  fi
  echo "  - kvantum style -> $CFG/Kvantum/AngelLevel/ (widgetStyle=kvantum)"
fi

# 6. Look-and-Feel (Global Theme: ties colours/icons/decoration/splash together)
install -d "$DATA/plasma/look-and-feel"
rm -rf "$DATA/plasma/look-and-feel/org.angellevel.desktop"
cp -R "$SRC/plasma/look-and-feel/org.angellevel.desktop" "$DATA/plasma/look-and-feel/org.angellevel.desktop"
echo "  - global theme  -> $DATA/plasma/look-and-feel/org.angellevel.desktop/"

# 6b. Updates plasmoid (panel applet)
if [ -d "$SRC/plasma/plasmoids/org.angellevel.updates" ]; then
  install -d "$DATA/plasma/plasmoids"
  rm -rf "$DATA/plasma/plasmoids/org.angellevel.updates"
  cp -R "$SRC/plasma/plasmoids/org.angellevel.updates" "$DATA/plasma/plasmoids/org.angellevel.updates"
  echo "  - plasmoid      -> $DATA/plasma/plasmoids/org.angellevel.updates/ (add to a panel)"
fi

# 7. Application launchers (.desktop entries for the branded apps)
if compgen -G "$SRC/applications/*.desktop" >/dev/null; then
  install -d "$DATA/applications"
  install -m 644 "$SRC/applications/"*.desktop "$DATA/applications/"
  n=$(ls "$SRC/applications/"*.desktop | wc -l | tr -d ' ')
  echo "  - launchers     -> $DATA/applications/ ($n entries)"
  # Refresh the desktop database so the launchers appear in the app menu.
  if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$DATA/applications" 2>/dev/null || true
  fi
fi

# 8. Package MIME types (so .tardist, FreeBSD/SysV .pkg and Arch packages get icons)
if [ -f "$SRC/mime/packages/angellevel-packages.xml" ]; then
  install -d "$DATA/mime/packages"
  install -m 644 "$SRC/mime/packages/"*.xml "$DATA/mime/packages/"
  echo "  - mime types    -> $DATA/mime/packages/"
  if command -v update-mime-database >/dev/null 2>&1; then
    update-mime-database "$DATA/mime" 2>/dev/null || true
  fi
fi

# 9. Software-update notifier (systemd user timer using the themed status icons)
if [ -f "$SRC/tools/angellevel-update-notifier" ]; then
  install -d "$HOME/.local/bin"
  install -m 755 "$SRC/tools/angellevel-update-notifier" "$HOME/.local/bin/angellevel-update-notifier"
  install -d "${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
  install -m 644 "$SRC/tools/systemd/"*.service "$SRC/tools/systemd/"*.timer \
    "${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user/"
  echo "  - update notify -> $HOME/.local/bin/angellevel-update-notifier (+ systemd user timer)"
  if command -v systemctl >/dev/null 2>&1 && [ -n "${XDG_RUNTIME_DIR:-}" ]; then
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable --now angellevel-update-notifier.timer 2>/dev/null || true
  fi
fi

# 10. KRunner "check for updates" plugin (D-Bus runner; needs python3-dbus + python3-gi)
if [ -f "$SRC/tools/krunner/angellevel-updates-runner" ]; then
  install -d "$HOME/.local/bin"
  install -m 755 "$SRC/tools/krunner/angellevel-updates-runner" "$HOME/.local/bin/angellevel-updates-runner"
  install -d "$DATA/krunner/dbusplugins"
  install -m 644 "$SRC/tools/krunner/plasma-runner-angellevel-updates.desktop" "$DATA/krunner/dbusplugins/"
  install -d "$DATA/dbus-1/services"
  sed "s|__BIN__|$HOME/.local/bin/angellevel-updates-runner|" \
    "$SRC/tools/krunner/org.angellevel.updatesrunner.service.in" \
    > "$DATA/dbus-1/services/org.angellevel.updatesrunner.service"
  echo "  - krunner       -> $DATA/krunner/dbusplugins/ (type 'updates' in KRunner)"
  if command -v kquitapp6 >/dev/null 2>&1; then kquitapp6 krunner 2>/dev/null || true
  elif command -v kquitapp5 >/dev/null 2>&1; then kquitapp5 krunner 2>/dev/null || true; fi
fi

cat <<'EOF'

Done. Now apply it:

  Color scheme:
    System Settings -> Colors -> "AngelLevel"
    (or:  plasma-apply-colorscheme AngelLevel)

  Window decoration:
    System Settings -> Window Decorations -> "AngelLevel"

  Konsole:
    Konsole -> Settings -> Edit Profile -> Appearance -> "AngelLevel"

  Icon theme:
    System Settings -> Icons -> "AngelLevel"
    (or:  plasma-changeicons AngelLevel)

  Plasma style (widgets):
    System Settings -> Plasma Style -> "AngelLevel"
    (or:  plasma-apply-desktoptheme AngelLevel)

  Everything at once (Global Theme):
    System Settings -> Global Theme -> "AngelLevel"
    (or:  lookandfeeltool -a org.angellevel.desktop)
    To revert:  lookandfeeltool -a org.kde.breeze.desktop

  Application launchers:
    The branded .desktop entries are in the application menu now (adjust each
    Exec= to match how the app is installed on your system, e.g. Flatpak/Snap).
    To remove them:  rm ~/.local/share/applications/{discord,vlc,gimp,...}.desktop

  Software-update notifications:
    A systemd user timer runs angellevel-update-notifier every 6 hours and shows
    a themed "updates available" notification. Run it now:
      angellevel-update-notifier
    Check the timer:  systemctl --user status angellevel-update-notifier.timer
    For instant post-transaction alerts, install a package-manager hook — see
    tools/hooks/README.md (Arch/Debian/Fedora).

  KRunner "check for updates":
    Open KRunner (Alt+Space) and type "updates" to check for / open software
    updates. Needs python3-dbus + python3-gi; if it doesn't appear, enable it in
    System Settings -> Search -> Plasma Search -> "AngelLevel Software Updates".

  Updates plasmoid:
    Right-click a panel -> Add Widgets -> "AngelLevel Updates" to show the update
    status + count in the panel (click opens Discover).

  Cursor + application style:
    The Global Theme now applies the AngelLevel IRIX cursors and the Kvantum
    widget style automatically. For Kvantum to render, install the engine:
      Arch: sudo pacman -S kvantum   Debian/Ubuntu: sudo apt install qt6-style-kvantum
    (Without it, Qt falls back to Breeze/Fusion — nothing breaks.)

  Recommended for the full NeXT feel:
    - Fonts: a Helvetica-like face (Nimbus Sans / Liberation Sans) fits best.
    - Window button order: put Minimize on the LEFT and Close on the RIGHT
      under Window Decorations -> Titlebar Buttons.

EOF
