#!/usr/bin/env bash
#
# Installs the SquirrelLevel Plasma theme bundle into the current user's
# ~/.local/share tree. Re-run safely; it overwrites previous copies.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

echo "Installing SquirrelLevel Plasma theme from: $SRC"
echo "Target data dir: $DATA"

# 1. Color scheme
install -d "$DATA/color-schemes"
install -m 644 "$SRC/color-schemes/SquirrelLevel.colors" "$DATA/color-schemes/SquirrelLevel.colors"
echo "  - color scheme  -> $DATA/color-schemes/SquirrelLevel.colors"

# 2. Aurorae window decoration
install -d "$DATA/aurorae/themes/SquirrelLevel"
install -m 644 "$SRC/aurorae/SquirrelLevel/"* "$DATA/aurorae/themes/SquirrelLevel/"
echo "  - window decor  -> $DATA/aurorae/themes/SquirrelLevel/"

# 3. Konsole color scheme
install -d "$DATA/konsole"
install -m 644 "$SRC/konsole/SquirrelLevel.colorscheme" "$DATA/konsole/SquirrelLevel.colorscheme"
echo "  - konsole       -> $DATA/konsole/SquirrelLevel.colorscheme"

# 4. Icon theme (cp -R preserves the alias symlinks inside the tree)
install -d "$DATA/icons"
rm -rf "$DATA/icons/SquirrelLevel"
cp -R "$SRC/icons/SquirrelLevel" "$DATA/icons/SquirrelLevel"
echo "  - icon theme    -> $DATA/icons/SquirrelLevel/"
# Refresh the icon cache if the tool is present (not required by KDE).
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -f -t "$DATA/icons/SquirrelLevel" 2>/dev/null || true
fi

# 5. Plasma Style (desktop/widget theme)
install -d "$DATA/plasma/desktoptheme"
rm -rf "$DATA/plasma/desktoptheme/SquirrelLevel"
cp -R "$SRC/plasma/desktoptheme/SquirrelLevel" "$DATA/plasma/desktoptheme/SquirrelLevel"
echo "  - plasma style  -> $DATA/plasma/desktoptheme/SquirrelLevel/"

# 6. Look-and-Feel (Global Theme: ties colours/icons/decoration/splash together)
install -d "$DATA/plasma/look-and-feel"
rm -rf "$DATA/plasma/look-and-feel/org.squirrellevel.desktop"
cp -R "$SRC/plasma/look-and-feel/org.squirrellevel.desktop" "$DATA/plasma/look-and-feel/org.squirrellevel.desktop"
echo "  - global theme  -> $DATA/plasma/look-and-feel/org.squirrellevel.desktop/"

cat <<'EOF'

Done. Now apply it:

  Color scheme:
    System Settings -> Colors -> "SquirrelLevel"
    (or:  plasma-apply-colorscheme SquirrelLevel)

  Window decoration:
    System Settings -> Window Decorations -> "SquirrelLevel"

  Konsole:
    Konsole -> Settings -> Edit Profile -> Appearance -> "SquirrelLevel"

  Icon theme:
    System Settings -> Icons -> "SquirrelLevel"
    (or:  plasma-changeicons SquirrelLevel)

  Plasma style (widgets):
    System Settings -> Plasma Style -> "SquirrelLevel"
    (or:  plasma-apply-desktoptheme SquirrelLevel)

  Everything at once (Global Theme):
    System Settings -> Global Theme -> "SquirrelLevel"
    (or:  lookandfeeltool -a org.squirrellevel.desktop)
    To revert:  lookandfeeltool -a org.kde.breeze.desktop

  Recommended for the full NeXT feel:
    - Set the application style (Kvantum/Breeze) and fonts separately;
      a Helvetica-like font (e.g. Nimbus Sans / Liberation Sans) fits best.
    - Window button order: put Minimize on the LEFT and Close on the RIGHT
      under Window Decorations -> Titlebar Buttons.

EOF
