#!/usr/bin/env bash
#
# Installs the SquirrelLevel Kvantum theme for the current user.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/SquirrelLevel"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/Kvantum/SquirrelLevel"

install -d "$DEST"
install -m 644 "$SRC/SquirrelLevel.kvconfig" "$DEST/SquirrelLevel.kvconfig"
install -m 644 "$SRC/SquirrelLevel.svg"      "$DEST/SquirrelLevel.svg"
echo "Installed Kvantum theme -> $DEST"
echo
echo "Activate it:"
echo "  kvantummanager --set SquirrelLevel"
echo "Then make Qt apps use the Kvantum engine:"
echo "  System Settings -> Application Style -> Kvantum   (Plasma)"
echo "  or set Style=kvantum in qt5ct / qt6ct             (other DEs)"
