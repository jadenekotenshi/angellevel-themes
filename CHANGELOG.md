# Changelog

All notable changes to the **AngelLevel / TenshiNET** theme suite are documented
here. Format based on [Keep a Changelog](https://keepachangelog.com/); this
project aims to follow [Semantic Versioning](https://semver.org/).

## [1.0.0] — 2026-07-02

First stable release: a complete NeXTSTEP / OPENSTEP-inspired theme suite for the
whole boot-to-desktop chain, in coordinated **light** and **dark** variants.
Brand: *TenshiNET*; emblem: a stylized OPENSTEP angel.

### Global theme (KDE Plasma)
- **Look-and-Feel** Global Theme `org.angellevel.desktop` tying colours, icons,
  decoration and splash together, with the angel as its icon.
- **KColorScheme** `AngelLevel.colors` — metallic indigo / gunmetal palette.
- **Aurorae** window decoration — NeXT 9-slice bevels, symmetric close-X, and an
  8 px NeXT-style bottom resize bar with grooved handles.
- **Konsole** colour scheme.
- **Plasma Style** (desktop/widget theme) — NeXT inset wells on combobox /
  spinbox dropdowns and slider / scrollbar dimples.
- **Kvantum** theme, **QSS**, and a native **QStyle** proxy (`AngelLevelStyle`).

### Icon theme (light + dark)
~550 hand-authored source icons per variant (≈1,090 names including aliases),
NeXT-idiom with `#1a1a1a` chiselled outlines:
- **apps** (96) — desktop utilities, browsers, terminals (kitty, alacritty,
  xterm, foot, wezterm, cool-retro-term, konsole), the GNUstep suite, 40+ brand
  apps, games & launchers, package managers, and Discover backends.
- **mimetypes** (305) — an encyclopedic set across 20+ emblem families:
  packages (incl. four magic-differentiated `.pkg` variants: macOS, NeXTSTEP,
  FreeBSD, SysV), archives & compression, encoded text, video, image, AI/ML
  models (safetensors, GGUF, ONNX, …), audio, libraries & executables, config /
  registry / plist, disk & VM images, shell / perl / awk scripts, build systems,
  office documents (RTF, CSV, AbiWord, iWork, StarOffice), fonts, e-books,
  vintage software (console ROMs & retro disks), uncommon & vintage languages,
  scientific / data (FITS, Parquet, HDF, …), CAD / 3D, GIS, network captures
  (pcap/pcapng/HAR), and MIDI / DAW project files.
- **status** (61) incl. software-update states and monochrome `-symbolic` tray
  badges (KDE `ColorScheme-Text`).
- **devices**, **places**, **actions**.

### Boot chain
- **SDDM** greeter (aspect-aware panel drop for 4:3 / 5:4).
- **Plymouth** boot splash.
- **rEFInd** theme (light + dark) with banner, selection, 46 OS icons and
  `.desktop`-style aliases; HiDPI EFI splashes.
- A canonical high angel position held across **EFI → rEFInd → Plymouth → SDDM →
  desktop**, with matching handoff wallpapers, so each stage cross-fades.
- Boot-sequence animation (`demo/boot-sequence.gif`).

### Applications & MIME
- 56 branded `.desktop` launchers with `StartupWMClass` hints and `openapp`
  fallbacks for GNUstep apps.
- shared-mime-info definitions (`mime/packages/angellevel-*.xml`) for the
  non-standard types, with content **magic** where available (xar!, SVR4
  datastream, GGUF, HDF5, registry hive `regf`, FITS, Parquet, pcap, tracker
  modules, …).

### Software-update stack
- `angellevel-update-notifier` — detects pacman/apt/dnf/zypper/flatpak and
  notifies with the themed icons; ships a **systemd user timer** and example
  pacman/apt hooks.
- A **KRunner** "check for updates" D-Bus runner.
- An **updates plasmoid** (panel applet) showing status + count.
- Discover backend icons (Flathub, Snap Store, fwupd, repository).

### Install
- `angellevel-plasma/install.sh` installs every component into the user's
  `~/.local` tree (colour scheme, decoration, Konsole, icons, Plasma style,
  Global Theme, plasmoid, launchers, MIME types, update notifier, KRunner) and
  refreshes the relevant caches.
- 23 rendered preview sheets under `angellevel-plasma/previews/`.

### Notes
- Visual assets were authored and validated via an SVG→PNG mock pipeline on
  macOS (no live Plasma/KWin/SDDM/rEFInd on hand); icons are NeXT-idiom
  reinterpretations, not official logos. Verify on live KDE.

[1.0.0]: #100--2026-07-02
