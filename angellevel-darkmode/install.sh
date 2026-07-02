#!/usr/bin/env bash
#
# Installs the AngelLevel-darkmode Plasma theme bundle into the current user's
# ~/.local/share tree. Re-run safely; it overwrites previous copies.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

echo "Installing AngelLevel-darkmode Plasma theme from: $SRC"
echo "Target data dir: $DATA"

# 1. Color scheme
install -d "$DATA/color-schemes"
install -m 644 "$SRC/color-schemes/AngelLevel-darkmode.colors" "$DATA/color-schemes/AngelLevel-darkmode.colors"
echo "  - color scheme  -> $DATA/color-schemes/AngelLevel-darkmode.colors"

# 2. Aurorae window decoration
install -d "$DATA/aurorae/themes/AngelLevel-darkmode"
install -m 644 "$SRC/aurorae/AngelLevel-darkmode/"* "$DATA/aurorae/themes/AngelLevel-darkmode/"
echo "  - window decor  -> $DATA/aurorae/themes/AngelLevel-darkmode/"

# 3. Konsole color scheme
install -d "$DATA/konsole"
install -m 644 "$SRC/konsole/AngelLevel-darkmode.colorscheme" "$DATA/konsole/AngelLevel-darkmode.colorscheme"
echo "  - konsole       -> $DATA/konsole/AngelLevel-darkmode.colorscheme"

# 4. Icon theme (dark set; cp -R preserves the alias symlinks)
install -d "$DATA/icons"
rm -rf "$DATA/icons/AngelLevel-darkmode"
cp -R "$SRC/icons/AngelLevel-darkmode" "$DATA/icons/AngelLevel-darkmode"
echo "  - icon theme    -> $DATA/icons/AngelLevel-darkmode/"
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -f -t "$DATA/icons/AngelLevel-darkmode" 2>/dev/null || true
fi

# 5. Plasma Style (desktop/widget theme)
install -d "$DATA/plasma/desktoptheme"
rm -rf "$DATA/plasma/desktoptheme/AngelLevel-darkmode"
cp -R "$SRC/plasma/desktoptheme/AngelLevel-darkmode" "$DATA/plasma/desktoptheme/AngelLevel-darkmode"
echo "  - plasma style  -> $DATA/plasma/desktoptheme/AngelLevel-darkmode/"

# 6. Look-and-Feel (Global Theme: ties colours/icons/decoration/splash together)
install -d "$DATA/plasma/look-and-feel"
rm -rf "$DATA/plasma/look-and-feel/org.angellevel.darkmode.desktop"
cp -R "$SRC/plasma/look-and-feel/org.angellevel.darkmode.desktop" "$DATA/plasma/look-and-feel/org.angellevel.darkmode.desktop"
echo "  - global theme  -> $DATA/plasma/look-and-feel/org.angellevel.darkmode.desktop/"

cat <<'EOF'

Done. Now apply it:

  Color scheme:
    System Settings -> Colors -> "AngelLevel-darkmode"
    (or:  plasma-apply-colorscheme AngelLevel-darkmode)

  Window decoration:
    System Settings -> Window Decorations -> "AngelLevel-darkmode"

  Konsole:
    Konsole -> Settings -> Edit Profile -> Appearance -> "AngelLevel-darkmode"

  Icon theme:
    System Settings -> Icons -> "AngelLevel-darkmode"
    (or:  plasma-changeicons AngelLevel-darkmode)

  Plasma style (widgets):
    System Settings -> Plasma Style -> "AngelLevel-darkmode"
    (or:  plasma-apply-desktoptheme AngelLevel-darkmode)

  Everything at once (Global Theme):
    System Settings -> Global Theme -> "AngelLevel-darkmode"
    (or:  lookandfeeltool -a org.angellevel.darkmode.desktop)
    To revert:  lookandfeeltool -a org.kde.breeze.desktop

  Recommended for the full NeXT feel:
    - Set the application style (Kvantum/Breeze) and fonts separately;
      a Helvetica-like font (e.g. Nimbus Sans / Liberation Sans) fits best.
    - Window button order: put Minimize on the LEFT and Close on the RIGHT
      under Window Decorations -> Titlebar Buttons.

EOF
