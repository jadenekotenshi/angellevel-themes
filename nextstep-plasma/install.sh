#!/usr/bin/env bash
#
# Installs the NeXTSTEP Plasma theme bundle into the current user's
# ~/.local/share tree. Re-run safely; it overwrites previous copies.
#
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"

echo "Installing NeXTSTEP Plasma theme from: $SRC"
echo "Target data dir: $DATA"

# 1. Color scheme
install -d "$DATA/color-schemes"
install -m 644 "$SRC/color-schemes/NeXTSTEP.colors" "$DATA/color-schemes/NeXTSTEP.colors"
echo "  - color scheme  -> $DATA/color-schemes/NeXTSTEP.colors"

# 2. Aurorae window decoration
install -d "$DATA/aurorae/themes/NeXTSTEP"
install -m 644 "$SRC/aurorae/NeXTSTEP/"* "$DATA/aurorae/themes/NeXTSTEP/"
echo "  - window decor  -> $DATA/aurorae/themes/NeXTSTEP/"

# 3. Konsole color scheme
install -d "$DATA/konsole"
install -m 644 "$SRC/konsole/NeXTSTEP.colorscheme" "$DATA/konsole/NeXTSTEP.colorscheme"
echo "  - konsole       -> $DATA/konsole/NeXTSTEP.colorscheme"

cat <<'EOF'

Done. Now apply it:

  Color scheme:
    System Settings -> Colors -> "NeXTSTEP"
    (or:  plasma-apply-colorscheme NeXTSTEP)

  Window decoration:
    System Settings -> Window Decorations -> "NeXTSTEP"

  Konsole:
    Konsole -> Settings -> Edit Profile -> Appearance -> "NeXTSTEP"

  Recommended for the full NeXT feel:
    - Set the application style (Kvantum/Breeze) and fonts separately;
      a Helvetica-like font (e.g. Nimbus Sans / Liberation Sans) fits best.
    - Window button order: put Minimize on the LEFT and Close on the RIGHT
      under Window Decorations -> Titlebar Buttons.

EOF
