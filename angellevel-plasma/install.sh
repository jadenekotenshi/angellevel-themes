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

# 5. Plasma Style (desktop/widget theme)
install -d "$DATA/plasma/desktoptheme"
rm -rf "$DATA/plasma/desktoptheme/AngelLevel"
cp -R "$SRC/plasma/desktoptheme/AngelLevel" "$DATA/plasma/desktoptheme/AngelLevel"
echo "  - plasma style  -> $DATA/plasma/desktoptheme/AngelLevel/"

# 6. Look-and-Feel (Global Theme: ties colours/icons/decoration/splash together)
install -d "$DATA/plasma/look-and-feel"
rm -rf "$DATA/plasma/look-and-feel/org.angellevel.desktop"
cp -R "$SRC/plasma/look-and-feel/org.angellevel.desktop" "$DATA/plasma/look-and-feel/org.angellevel.desktop"
echo "  - global theme  -> $DATA/plasma/look-and-feel/org.angellevel.desktop/"

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

  Recommended for the full NeXT feel:
    - Set the application style (Kvantum/Breeze) and fonts separately;
      a Helvetica-like font (e.g. Nimbus Sans / Liberation Sans) fits best.
    - Window button order: put Minimize on the LEFT and Close on the RIGHT
      under Window Decorations -> Titlebar Buttons.

EOF
