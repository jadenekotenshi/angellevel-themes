#!/usr/bin/env bash
#
# Installs the AngelLevel Kvantum theme for the current user.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/AngelLevel"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/Kvantum/AngelLevel"

install -d "$DEST"
install -m 644 "$SRC/AngelLevel.kvconfig" "$DEST/AngelLevel.kvconfig"
install -m 644 "$SRC/AngelLevel.svg"      "$DEST/AngelLevel.svg"
echo "Installed Kvantum theme -> $DEST"
echo
echo "Activate it:"
echo "  kvantummanager --set AngelLevel"
echo "Then make Qt apps use the Kvantum engine:"
echo "  System Settings -> Application Style -> Kvantum   (Plasma)"
echo "  or set Style=kvantum in qt5ct / qt6ct             (other DEs)"
