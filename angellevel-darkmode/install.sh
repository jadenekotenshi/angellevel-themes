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
[ -f "$SRC/konsole/AngelLevel-darkmode.profile" ] && \
  install -m 644 "$SRC/konsole/AngelLevel-darkmode.profile" "$DATA/konsole/AngelLevel-darkmode.profile"
echo "  - konsole       -> $DATA/konsole/AngelLevel-darkmode.{colorscheme,profile}"

# 4. Icon theme (dark set; cp -R preserves the alias symlinks)
install -d "$DATA/icons"
rm -rf "$DATA/icons/AngelLevel-darkmode"
cp -R "$SRC/icons/AngelLevel-darkmode" "$DATA/icons/AngelLevel-darkmode"
echo "  - icon theme    -> $DATA/icons/AngelLevel-darkmode/"
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -f -t "$DATA/icons/AngelLevel-darkmode" 2>/dev/null || true
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
rm -rf "$DATA/plasma/desktoptheme/AngelLevel-darkmode"
cp -R "$SRC/plasma/desktoptheme/AngelLevel-darkmode" "$DATA/plasma/desktoptheme/AngelLevel-darkmode"
echo "  - plasma style  -> $DATA/plasma/desktoptheme/AngelLevel-darkmode/"

# 5b. Kvantum application style (the chiselled NeXT widget look; needs the
#     Kvantum engine installed for widgetStyle=kvantum to take effect).
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
if [ -d "$SRC/kvantum/AngelLevel-darkmode" ]; then
  install -d "$CFG/Kvantum/AngelLevel-darkmode"
  install -m 644 "$SRC/kvantum/AngelLevel-darkmode/"* "$CFG/Kvantum/AngelLevel-darkmode/"
  if command -v kvantummanager >/dev/null 2>&1; then
    kvantummanager --set AngelLevel-darkmode >/dev/null 2>&1 || true
  elif [ ! -f "$CFG/Kvantum/kvantum.kvconfig" ]; then
    printf '[General]\ntheme=AngelLevel-darkmode\n' > "$CFG/Kvantum/kvantum.kvconfig"
  fi
  echo "  - kvantum style -> $CFG/Kvantum/AngelLevel-darkmode/ (widgetStyle=kvantum)"
fi

# 5c. GTK theme (so GTK/GNOME apps match the NeXT look under Plasma)
if [ -d "$SRC/gtk/AngelLevel-darkmode" ]; then
  install -d "$DATA/themes/AngelLevel-darkmode"
  cp -R "$SRC/gtk/AngelLevel-darkmode/"* "$DATA/themes/AngelLevel-darkmode/"
  echo "  - gtk theme     -> $DATA/themes/AngelLevel-darkmode/ (apply via kde-gtk-config, or"
  echo "                     gsettings set org.gnome.desktop.interface gtk-theme AngelLevel-darkmode)"
fi

# 5d. Wallpaper package (selectable in Desktop -> Wallpaper)
if [ -d "$SRC/wallpaper/AngelLevel-darkmode" ]; then
  install -d "$DATA/wallpapers"
  rm -rf "$DATA/wallpapers/AngelLevel-darkmode"
  cp -R "$SRC/wallpaper/AngelLevel-darkmode" "$DATA/wallpapers/AngelLevel-darkmode"
  echo "  - wallpaper     -> $DATA/wallpapers/AngelLevel-darkmode/ (Desktop -> Wallpaper)"
fi

# 6. Look-and-Feel (Global Theme: ties colours/icons/decoration/splash together)
install -d "$DATA/plasma/look-and-feel"
rm -rf "$DATA/plasma/look-and-feel/org.angellevel.darkmode.desktop"
cp -R "$SRC/plasma/look-and-feel/org.angellevel.darkmode.desktop" "$DATA/plasma/look-and-feel/org.angellevel.darkmode.desktop"
echo "  - global theme  -> $DATA/plasma/look-and-feel/org.angellevel.darkmode.desktop/"

# 6-style. Point the Global Theme's widgetStyle at the best style actually
# present on THIS system (kvantum / compiled AngelLevel QStyle), else keep
# Breeze so applying the theme never yields an unstyled/broken look.
LNF_DEFAULTS="$DATA/plasma/look-and-feel/org.angellevel.darkmode.desktop/contents/defaults"
WSTYLE=Breeze
if command -v kvantummanager >/dev/null 2>&1; then
  WSTYLE=kvantum
elif find /usr/lib /usr/lib64 /usr/lib/*-linux-gnu -maxdepth 6 -path '*plugins/styles*' \
        -iname '*angellevel*' 2>/dev/null | grep -q .; then
  WSTYLE=AngelLevel
fi
if [ -f "$LNF_DEFAULTS" ]; then
  sed -i.bak "s/^widgetStyle=.*/widgetStyle=$WSTYLE/" "$LNF_DEFAULTS" && rm -f "$LNF_DEFAULTS.bak"
fi
echo "  - widget style  -> $WSTYLE (Global Theme default)"
if [ "$WSTYLE" = Breeze ]; then
  echo "                     for the NeXT widgets: install 'kvantum', OR build the"
  echo "                     bundled QStyle (qstyle/build-and-install.sh), then re-run."
fi

# 6a. KWin window switcher (Alt-Tab) skin
if [ -d "$SRC/plasma/kwin/tabbox/org.angellevel.darkmode.switcher" ]; then
  install -d "$DATA/kwin/tabbox"
  rm -rf "$DATA/kwin/tabbox/org.angellevel.darkmode.switcher"
  cp -R "$SRC/plasma/kwin/tabbox/org.angellevel.darkmode.switcher" "$DATA/kwin/tabbox/org.angellevel.darkmode.switcher"
  echo "  - alt-tab switch-> $DATA/kwin/tabbox/org.angellevel.darkmode.switcher/"
fi

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

  Cursor + application style:
    The Global Theme applies the AngelLevel IRIX cursors automatically. The
    chiselled NeXT WIDGET look needs one of two backends; this installer already
    pointed the Global Theme at whichever it found ("widget style ->" above):
      - Kvantum engine:  Arch: sudo pacman -S kvantum
                         Debian/Ubuntu: sudo apt install qt6-style-kvantum
      - or the bundled compiled QStyle (no engine needed):
                         cd qstyle && ./build-and-install.sh   (needs cmake + Qt dev)
    Install one, then re-run this script so it switches widgetStyle away from
    Breeze. Without either, widgets stay Breeze — nothing breaks.

  Recommended for the full NeXT feel:
    - Fonts: a Helvetica-like face (Nimbus Sans / Liberation Sans) fits best.
    - Window button order: put Minimize on the LEFT and Close on the RIGHT
      under Window Decorations -> Titlebar Buttons.

EOF
