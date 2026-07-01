#!/usr/bin/env bash
#
# Installs the SquirrelLevel-darkmode Plasma theme bundle into the current user's
# ~/.local/share tree. Re-run safely; it overwrites previous copies.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

echo "Installing SquirrelLevel-darkmode Plasma theme from: $SRC"
echo "Target data dir: $DATA"

# 1. Color scheme
install -d "$DATA/color-schemes"
install -m 644 "$SRC/color-schemes/SquirrelLevel-darkmode.colors" "$DATA/color-schemes/SquirrelLevel-darkmode.colors"
echo "  - color scheme  -> $DATA/color-schemes/SquirrelLevel-darkmode.colors"

# 2. Aurorae window decoration
install -d "$DATA/aurorae/themes/SquirrelLevel-darkmode"
install -m 644 "$SRC/aurorae/SquirrelLevel-darkmode/"* "$DATA/aurorae/themes/SquirrelLevel-darkmode/"
echo "  - window decor  -> $DATA/aurorae/themes/SquirrelLevel-darkmode/"

# 3. Konsole color scheme
install -d "$DATA/konsole"
install -m 644 "$SRC/konsole/SquirrelLevel-darkmode.colorscheme" "$DATA/konsole/SquirrelLevel-darkmode.colorscheme"
echo "  - konsole       -> $DATA/konsole/SquirrelLevel-darkmode.colorscheme"

# (Icons are shared: install the light SquirrelLevel bundle for the icon theme.)

# 5. Plasma Style (desktop/widget theme)
install -d "$DATA/plasma/desktoptheme"
rm -rf "$DATA/plasma/desktoptheme/SquirrelLevel-darkmode"
cp -R "$SRC/plasma/desktoptheme/SquirrelLevel-darkmode" "$DATA/plasma/desktoptheme/SquirrelLevel-darkmode"
echo "  - plasma style  -> $DATA/plasma/desktoptheme/SquirrelLevel-darkmode/"

# 6. Look-and-Feel (Global Theme: ties colours/icons/decoration/splash together)
install -d "$DATA/plasma/look-and-feel"
rm -rf "$DATA/plasma/look-and-feel/org.squirrellevel.darkmode.desktop"
cp -R "$SRC/plasma/look-and-feel/org.squirrellevel.darkmode.desktop" "$DATA/plasma/look-and-feel/org.squirrellevel.darkmode.desktop"
echo "  - global theme  -> $DATA/plasma/look-and-feel/org.squirrellevel.darkmode.desktop/"

cat <<'EOF'

Done. Now apply it:

  Color scheme:
    System Settings -> Colors -> "SquirrelLevel-darkmode"
    (or:  plasma-apply-colorscheme SquirrelLevel-darkmode)

  Window decoration:
    System Settings -> Window Decorations -> "SquirrelLevel-darkmode"

  Konsole:
    Konsole -> Settings -> Edit Profile -> Appearance -> "SquirrelLevel-darkmode"

  Icons (shared with the light theme):
    install the SquirrelLevel bundle too, then System Settings -> Icons -> "SquirrelLevel"

  Plasma style (widgets):
    System Settings -> Plasma Style -> "SquirrelLevel-darkmode"
    (or:  plasma-apply-desktoptheme SquirrelLevel-darkmode)

  Everything at once (Global Theme):
    System Settings -> Global Theme -> "SquirrelLevel-darkmode"
    (or:  lookandfeeltool -a org.squirrellevel.darkmode.desktop)
    To revert:  lookandfeeltool -a org.kde.breeze.desktop

  Recommended for the full NeXT feel:
    - Set the application style (Kvantum/Breeze) and fonts separately;
      a Helvetica-like font (e.g. Nimbus Sans / Liberation Sans) fits best.
    - Window button order: put Minimize on the LEFT and Close on the RIGHT
      under Window Decorations -> Titlebar Buttons.

EOF
