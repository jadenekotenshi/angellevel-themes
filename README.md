# AngelLevel — a NeXTSTEP/OPENSTEP theme suite for KDE Plasma

A complete NeXTSTEP / OPENSTEP-inspired desktop and boot theme, branded
**TenshiNET** (emblem: a stylized OPENSTEP angel), in coordinated **light** and
**dark** variants.

## Bundles

| Directory | What it is |
|---|---|
| `angellevel-plasma/` | The light theme: Global Theme, colour scheme, Aurorae decoration, Konsole, Plasma style, Kvantum/QSS/QStyle, icon theme (~550 icons), SDDM, Plymouth, launchers, MIME types, and the software-update stack. Run `install.sh`. |
| `angellevel-darkmode/` | The dark icon theme variant (`AngelLevel-darkmode`). |
| `angellevel-refind/` | rEFInd boot theme (light + dark) with 46 OS icons and HiDPI EFI splashes. |
| `demo/` | The `EFI → rEFInd → Plymouth → SDDM → desktop` boot-sequence animation. |

## Install (Plasma)

```sh
cd angellevel-plasma
./install.sh
```

Then apply it under **System Settings → Global Theme → "AngelLevel"** (or
`lookandfeeltool -a org.angellevel.desktop`). The installer prints per-component
instructions and sets up the update notifier, KRunner action and plasmoid.

For the boot theme, see the `angellevel-refind/` bundle and the rendered sheets
under `angellevel-plasma/previews/`.

## Status

See [CHANGELOG.md](CHANGELOG.md). Current release: **v1.0.0**.

Assets were authored and validated via an SVG→PNG mock pipeline; icons are
NeXT-idiom reinterpretations rather than official logos. Verify on live KDE.
