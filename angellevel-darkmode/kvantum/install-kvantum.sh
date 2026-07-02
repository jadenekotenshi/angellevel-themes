#!/usr/bin/env bash
#
# Installs the AngelLevel-darkmode Kvantum theme for the current user.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/AngelLevel-darkmode"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/Kvantum/AngelLevel-darkmode"

install -d "$DEST"
install -m 644 "$SRC/AngelLevel-darkmode.kvconfig" "$DEST/AngelLevel-darkmode.kvconfig"
install -m 644 "$SRC/AngelLevel-darkmode.svg"      "$DEST/AngelLevel-darkmode.svg"
echo "Installed Kvantum theme -> $DEST"
echo
echo "Activate it:"
echo "  kvantummanager --set AngelLevel-darkmode"
echo "Then make Qt apps use the Kvantum engine:"
echo "  System Settings -> Application Style -> Kvantum   (Plasma)"
echo "  or set Style=kvantum in qt5ct / qt6ct             (other DEs)"
