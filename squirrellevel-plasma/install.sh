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

cat <<'EOF'

Done. Now apply it:

  Color scheme:
    System Settings -> Colors -> "SquirrelLevel"
    (or:  plasma-apply-colorscheme SquirrelLevel)

  Window decoration:
    System Settings -> Window Decorations -> "SquirrelLevel"

  Konsole:
    Konsole -> Settings -> Edit Profile -> Appearance -> "SquirrelLevel"

  Recommended for the full NeXT feel:
    - Set the application style (Kvantum/Breeze) and fonts separately;
      a Helvetica-like font (e.g. Nimbus Sans / Liberation Sans) fits best.
    - Window button order: put Minimize on the LEFT and Close on the RIGHT
      under Window Decorations -> Titlebar Buttons.

EOF
