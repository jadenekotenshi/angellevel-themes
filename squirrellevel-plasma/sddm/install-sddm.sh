#!/usr/bin/env bash
#
# Installs the SquirrelLevel SDDM login theme system-wide (requires sudo,
# since SDDM themes live under /usr/share). Then point SDDM at it.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/SquirrelLevel"
DEST=/usr/share/sddm/themes/SquirrelLevel

echo "Installing SDDM theme:"
echo "  from: $SRC"
echo "  to:   $DEST   (requires sudo)"
sudo mkdir -p "$DEST"
sudo cp -R "$SRC/." "$DEST/"

echo
echo "Activate it by creating /etc/sddm.conf.d/squirrellevel.conf with:"
echo
echo "  [Theme]"
echo "  Current=SquirrelLevel"
echo
echo "Preview/verify without logging out:"
echo "  sddm-greeter --test-mode --theme $DEST"
