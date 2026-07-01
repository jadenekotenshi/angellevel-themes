# SquirrelLevel for KDE Plasma

A NeXTSTEP/OpenStep-inspired theme bundle for KDE Plasma (5 and 6). It aims
for the classic NeXT look: flat grayscale palette, chiseled bevels (white
highlight on the top/left, dark shadow on the bottom/right), black title
text, and square title-bar buttons.

## What's included

| Piece | Path | What it themes |
|-------|------|----------------|
| Color scheme | `color-schemes/SquirrelLevel.colors` | App colors — NeXT grays, white views, dark selection |
| Window decoration | `aurorae/SquirrelLevel/` | Aurorae title bars & borders with beveled square buttons |
| Konsole scheme | `konsole/SquirrelLevel.colorscheme` | Terminal palette (black on white, muted ANSI) |
| Icon theme | `icons/SquirrelLevel/` | Grayscale, beveled icons; inherits Breeze for the rest |

Not included (out of scope for a from-scratch bundle): a full Plasma desktop
("look & feel") theme and an application *widget* style. For the most faithful
result, pair this with a flat application style — Kvantum with a grayscale
config, or Breeze tuned to the color scheme above — and a Helvetica-like font
such as Nimbus Sans or Liberation Sans.

### About the icon theme

KDE references thousands of icon names, so this ships a **curated NeXT-style
core set** (≈101 hand-drawn icons plus ~155 alias links) covering the most
visible surfaces:

- **Places:** folders + typed variants (documents, downloads, pictures, music,
  videos), home, desktop, trash.
- **Devices:** hard disk, optical disc, USB flash, printer, keyboard, mouse,
  wired network, computer.
- **Actions:** new, save, copy, cut, paste, delete, find, refresh, back/forward,
  up, add/remove, OK, cancel/close, home, and media play/pause/stop.
- **Status (panel/tray):** battery (5 levels + charging, with `battery-100`…
  `battery-000` aliases), Wi-Fi signal strength (none→excellent + disconnected),
  Bluetooth (active/disabled), microphone (active/muted), volume high/muted,
  notifications + Do-Not-Disturb, software updates, VPN, brightness high/low,
  airplane mode, presence (online/offline/away/busy), and
  information/question/warning/error.
- **Emblems:** symbolic-link, locked/readonly, important, favorite, shared.
- **MimeTypes:** generic text, source code, HTML, shell script, PDF, fonts,
  images, audio, video, and archives — with family aliases (`image/png`,
  `audio/mpeg`, `video/mp4`, `application/zip`, `text-x-python`, …).
- **Apps:** Konsole, Dolphin, Kate, NEdit, Vim, VS Code, Okular, Gwenview,
  Spectacle, System Settings, Klipper, Chromium, and Firefox — each with the
  alternate names KDE looks up (`org.kde.*`, `chromium-browser`, `code`, …).

The theme **inherits from Breeze**, so any name not provided falls back to
Breeze automatically. Trade-off: until you extend the set, unprovided icons
keep their Breeze (colorful, flat) look alongside the grayscale ones. Add more
SVGs under the matching `icons/SquirrelLevel/<context>/scalable/` folder to grow
coverage.

Note: brand marks (Chromium, Firefox, VS Code, Vim) are **grayscale
reinterpretations** in the NeXT idiom, not the official colored logos.

## Install

```bash
./install.sh
```

This copies the files into
`~/.local/share/{color-schemes,aurorae/themes,konsole,icons}`. Nothing is
installed system-wide and nothing outside `~/.local/share` is touched.

### Manual install (equivalent)

```bash
mkdir -p ~/.local/share/{color-schemes,aurorae/themes,konsole,icons}
cp color-schemes/SquirrelLevel.colors      ~/.local/share/color-schemes/
cp -r aurorae/SquirrelLevel                 ~/.local/share/aurorae/themes/
cp konsole/SquirrelLevel.colorscheme        ~/.local/share/konsole/
cp -R icons/SquirrelLevel                   ~/.local/share/icons/
```

## Apply

- **Colors:** System Settings → Colors → *SquirrelLevel*
  (or `plasma-apply-colorscheme SquirrelLevel`)
- **Window decoration:** System Settings → Window Decorations → *SquirrelLevel*
- **Konsole:** Konsole → Settings → Edit Current Profile → Appearance → *SquirrelLevel*
- **Icons:** System Settings → Icons → *SquirrelLevel*
  (or `plasma-changeicons SquirrelLevel`)

For the authentic NeXT button arrangement, go to
**Window Decorations → Titlebar Buttons** and place **Minimize on the left**
and **Close on the right**.

## Tweaking the decoration

The window decoration is an [Aurorae](https://develop.kde.org/) SVG theme:

- `decoration.svg` — the 9-slice frame and title bar (active + inactive sets).
- `close.svg`, `minimize.svg`, `maximize.svg`, `restore.svg` — buttons, each
  with `*-active`, `*-hover`, `*-pressed`, `*-inactive`, `*-deactivated` states.
- `SquirrelLevelrc` — geometry: border thickness, title height, button size.

Bevel convention used throughout: `#ffffff` highlight on top/left edges,
`#6e6e6e` shadow on bottom/right, `#b0b0b0` gray fill, `#1a1a1a` outer frame.
Edit the hex values to taste, then re-run `install.sh` and reselect the
decoration (or toggle to another and back) to reload.

## Status / caveats

These files are written to the documented KDE color-scheme, Aurorae, and
Konsole formats, but they were **authored without a running Plasma session to
preview them** — so treat the first install as a test pass. Most likely spots
to need a nudge after you see it live:

- **Title-bar height / button alignment** — tune `TitleHeight`,
  `ButtonHeight`, and `ButtonMarginTop` in `SquirrelLevelrc`.
- **Button state element names** — Aurorae has varied these slightly across
  versions; if a button glyph doesn't show, check that the element ids in the
  button SVG match what your Plasma version expects.
- **Border thickness** — `BorderLeft/Right/Bottom` in `SquirrelLevelrc`.

Please report (or just fix) anything that renders off and the values above are
the first knobs to turn.
