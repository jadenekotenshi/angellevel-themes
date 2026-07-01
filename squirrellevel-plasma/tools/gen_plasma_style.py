#!/usr/bin/env python3
"""
Generate the SquirrelLevel Plasma Style (desktop theme) FrameSvg widgets:
NeXT chiselled bevels in the OPENSTEP palette. Each SVG carries the 9-slice
element ids (optionally prefixed by widget state) that Plasma's FrameSvg reads.
Plasma falls back to Breeze for any element/theme file not provided here.
"""
import os

OUT = os.path.join(os.path.dirname(__file__), '..', 'plasma', 'desktoptheme', 'SquirrelLevel')

FRAME = '#1a1a1a'
BLUE = '#5f5cae'

def region(ox, oy, w, h, rowpos, colpos, base, frame, raised):
    hi, sh = '#ffffff', '#6e6e6e'
    itl = hi if raised else '#868c93'
    ibr = sh if raised else '#ffffff'
    r = [f'<rect x="{ox}" y="{oy}" width="{w}" height="{h}" fill="{base}"/>']
    if rowpos == 'top':    r.append(f'<rect x="{ox}" y="{oy}" width="{w}" height="1" fill="{frame}"/>')
    if rowpos == 'bottom': r.append(f'<rect x="{ox}" y="{oy+h-1}" width="{w}" height="1" fill="{frame}"/>')
    if colpos == 'left':   r.append(f'<rect x="{ox}" y="{oy}" width="1" height="{h}" fill="{frame}"/>')
    if colpos == 'right':  r.append(f'<rect x="{ox+w-1}" y="{oy}" width="1" height="{h}" fill="{frame}"/>')
    if rowpos == 'top':    r.append(f'<rect x="{ox}" y="{oy+1}" width="{w}" height="1" fill="{itl}"/>')
    if colpos == 'left':   r.append(f'<rect x="{ox+1}" y="{oy}" width="1" height="{h}" fill="{itl}"/>')
    if rowpos == 'bottom': r.append(f'<rect x="{ox}" y="{oy+h-2}" width="{w}" height="1" fill="{ibr}"/>')
    if colpos == 'right':  r.append(f'<rect x="{ox+w-2}" y="{oy}" width="1" height="{h}" fill="{ibr}"/>')
    return r

def block(ox, oy, prefix, base, frame, raised, Wb=48, Hb=24, c=6):
    pre = (prefix + '-') if prefix else ''
    xs = [(ox, c, 'left'), (ox + c, Wb - 2 * c, 'mid'), (ox + Wb - c, c, 'right')]
    ys = [(oy, c, 'top'), (oy + c, Hb - 2 * c, 'mid'), (oy + Hb - c, c, 'bottom')]
    names = {('top', 'left'): 'topleft', ('top', 'mid'): 'top', ('top', 'right'): 'topright',
             ('mid', 'left'): 'left', ('mid', 'mid'): 'center', ('mid', 'right'): 'right',
             ('bottom', 'left'): 'bottomleft', ('bottom', 'mid'): 'bottom', ('bottom', 'right'): 'bottomright'}
    out = []
    for (yy, hh, rp) in ys:
        for (xx, ww, cp) in xs:
            nm = names[(rp, cp)]
            out.append(f'<g id="{pre}{nm}">' + ''.join(region(xx, yy, ww, hh, rp, cp, base, frame, raised)) + '</g>')
    return out

def svg(elems, w, h):
    return (f'<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n'
            f'<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}">\n  '
            + '\n  '.join(elems) + '\n</svg>\n')

def write(rel, text):
    p = os.path.join(OUT, rel)
    os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, 'w').write(text)

# --- widgets/button.svg : normal / hover / focus / pressed ---
b = []
b += block(4,   4, 'normal',  '#b0b0b0', FRAME, True)
b += block(4,  36, 'hover',   '#bcbcbc', FRAME, True)
b += block(4,  68, 'focus',   '#b6b6b6', BLUE,  True)
b += block(4, 100, 'pressed', '#9a9a9a', FRAME, False)
write('widgets/button.svg', svg(b, 60, 132))

# --- widgets/lineedit.svg : base / focus (recessed white) ---
le = []
le += block(4,  4, 'base',  '#ffffff', FRAME, False)
le += block(4, 36, 'focus', '#ffffff', BLUE,  False)
write('widgets/lineedit.svg', svg(le, 60, 68))

# --- single-prefix backgrounds (no state prefix) ---
write('widgets/panel-background.svg', svg(block(4, 4, '', '#a6b0bb', FRAME, True, 64, 44, 8), 76, 56))
write('widgets/background.svg',       svg(block(4, 4, '', '#b7bdc5', FRAME, True, 56, 40, 7), 68, 52))
write('dialogs/background.svg',       svg(block(4, 4, '', '#bcc2c9', FRAME, True, 64, 44, 8), 76, 56))
write('widgets/tooltip.svg',          svg(block(4, 4, '', '#e9e7db', FRAME, True, 56, 36, 6), 68, 48))
write('widgets/listitem.svg',         svg(block(4, 4, '', '#c4cad1', FRAME, True, 48, 24, 5), 60, 32))

print("generated Plasma Style SVGs under", os.path.relpath(OUT))
