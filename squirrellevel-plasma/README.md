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

Not included (out of scope for a from-scratch bundle): a full Plasma desktop
("look & feel") theme, an application *widget* style, and an icon theme. For
the most faithful result, pair this with a flat application style — Kvantum
with a grayscale config, or Breeze tuned to the color scheme above — and a
Helvetica-like font such as Nimbus Sans or Liberation Sans.

## Install

```bash
./install.sh
```

This copies the files into `~/.local/share/{color-schemes,aurorae/themes,konsole}`.
Nothing is installed system-wide and nothing outside `~/.local/share` is touched.

### Manual install (equivalent)

```bash
mkdir -p ~/.local/share/color-schemes ~/.local/share/aurorae/themes ~/.local/share/konsole
cp color-schemes/SquirrelLevel.colors      ~/.local/share/color-schemes/
cp -r aurorae/SquirrelLevel                 ~/.local/share/aurorae/themes/
cp konsole/SquirrelLevel.colorscheme        ~/.local/share/konsole/
```

## Apply

- **Colors:** System Settings → Colors → *SquirrelLevel*
  (or `plasma-apply-colorscheme SquirrelLevel`)
- **Window decoration:** System Settings → Window Decorations → *SquirrelLevel*
- **Konsole:** Konsole → Settings → Edit Current Profile → Appearance → *SquirrelLevel*

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
