#!/usr/bin/env python3
"""
Generate the SquirrelLevel Kvantum SVG (SquirrelLevel.svg). Kvantum looks up
widgets by SVG element id: interior = "<base>-<status>", frame parts =
"<base>-<status>-<edge>" (top/bottom/left/right + 4 corners). We bake the NeXT
chiselled bevel into the frame parts and keep a flat interior fill.

Authored without Kvantum to test against — verify/tune in Kvantum Manager.
"""
import os
OUT = os.path.join(os.path.dirname(__file__), '..', 'kvantum', 'SquirrelLevel')
FRAME = '#1a1a1a'; BLUE = '#5f5cae'
els = []
_y = [0]

def region(ox, oy, w, h, rp, cp, base, frame, raised):
    hi, sh = '#ffffff', '#6e6e6e'
    itl = hi if raised else '#868c93'
    ibr = sh if raised else '#ffffff'
    r = [f'<rect x="{ox}" y="{oy}" width="{w}" height="{h}" fill="{base}"/>']
    if rp == 'top':    r.append(f'<rect x="{ox}" y="{oy}" width="{w}" height="1" fill="{frame}"/>')
    if rp == 'bottom': r.append(f'<rect x="{ox}" y="{oy+h-1}" width="{w}" height="1" fill="{frame}"/>')
    if cp == 'left':   r.append(f'<rect x="{ox}" y="{oy}" width="1" height="{h}" fill="{frame}"/>')
    if cp == 'right':  r.append(f'<rect x="{ox+w-1}" y="{oy}" width="1" height="{h}" fill="{frame}"/>')
    if rp == 'top':    r.append(f'<rect x="{ox}" y="{oy+1}" width="{w}" height="1" fill="{itl}"/>')
    if cp == 'left':   r.append(f'<rect x="{ox+1}" y="{oy}" width="1" height="{h}" fill="{itl}"/>')
    if rp == 'bottom': r.append(f'<rect x="{ox}" y="{oy+h-2}" width="{w}" height="1" fill="{ibr}"/>')
    if cp == 'right':  r.append(f'<rect x="{ox+w-2}" y="{oy}" width="1" height="{h}" fill="{ibr}"/>')
    return ''.join(r)

def framed(base, status, fill, frame, raised, Wb=40, Hb=22, c=4, grip=False):
    oy = _y[0]; ox = 4; _y[0] += Hb + 6
    xs = [(ox, c, 'left'), (ox + c, Wb - 2 * c, 'mid'), (ox + Wb - c, c, 'right')]
    ys = [(oy, c, 'top'), (oy + c, Hb - 2 * c, 'mid'), (oy + Hb - c, c, 'bottom')]
    grid = {('top', 'left'): 'topleft', ('top', 'mid'): 'top', ('top', 'right'): 'topright',
            ('mid', 'left'): 'left', ('mid', 'mid'): None, ('mid', 'right'): 'right',
            ('bottom', 'left'): 'bottomleft', ('bottom', 'mid'): 'bottom', ('bottom', 'right'): 'bottomright'}
    for (yy, hh, rp) in ys:
        for (xx, ww, cp) in xs:
            edge = grid[(rp, cp)]
            eid = f'{base}-{status}' if edge is None else f'{base}-{status}-{edge}'
            extra = ''
            if edge is None and grip:
                # NeXT scroller knob: a small recessed indentation across the centre
                gy = yy + hh / 2
                extra = (f'<rect x="{xx+2}" y="{gy-1:.1f}" width="{ww-4}" height="1" fill="#5f6b76"/>'
                         f'<rect x="{xx+2}" y="{gy:.1f}" width="{ww-4}" height="1" fill="#ffffff"/>')
            els.append(f'<g id="{eid}">{region(xx, yy, ww, hh, rp, cp, fill, frame, raised)}{extra}</g>')

def indicator(base, status, draw, size=16):
    oy = _y[0]; ox = 4; _y[0] += size + 6
    els.append(f'<g id="{base}-{status}"><rect x="{ox}" y="{oy}" width="{size}" height="{size}" fill="#000000" fill-opacity="0"/>{draw(ox, oy, size)}</g>')

# framed widgets: (base, [(status, fill, frame, raised)])
FR = {
    'button': [('normal', '#b0b0b0', FRAME, True), ('focused', '#b6b6b6', BLUE, True),
               ('pressed', '#9a9a9a', FRAME, False), ('toggled', '#9fb0c4', FRAME, False),
               ('disabled', '#c4c4c4', '#9a9a9a', True)],
    'lineedit': [('normal', '#ffffff', FRAME, False), ('focused', '#ffffff', BLUE, False),
                 ('pressed', '#ffffff', FRAME, False), ('toggled', '#ffffff', FRAME, False),
                 ('disabled', '#ededed', '#9a9a9a', False)],
    'menu':    [('normal', '#b0b0b0', FRAME, True)],
    'tooltip': [('normal', '#e9e7db', FRAME, True)],
    'frame':   [('normal', '#b0b0b0', FRAME, False)],
    'toolbar': [('normal', '#aeb6bf', FRAME, True)],
    'group':   [('normal', '#b0b0b0', FRAME, False)],
    'progressbar':  [('normal', 'url(#mgroove)', FRAME, False)],
    'progress':     [('normal', 'url(#prog)', FRAME, True)],
    'slidergroove': [('normal', '#9aa2ac', FRAME, False)],
    'slidercursor': [('normal', '#b0b0b0', FRAME, True), ('focused', '#b6b6b6', BLUE, True),
                     ('pressed', '#9a9a9a', FRAME, False), ('disabled', '#c4c4c4', '#9a9a9a', True)],
    'scrollbargroove': [('normal', '#a2a8b0', FRAME, False)],
    'scrollbarcursor': [('normal', '#b0b0b0', FRAME, True), ('focused', '#b6b6b6', BLUE, True),
                        ('pressed', '#9a9a9a', FRAME, False), ('disabled', '#c4c4c4', '#9a9a9a', True)],
    'focus':   [('normal', '#00000000', BLUE, True)],
}
for base, sts in FR.items():
    for (status, fill, frame, raised) in sts:
        g = (base == 'scrollbarcursor')          # centre indentation on the scroller knob
        framed(base, status, fill, frame, raised, grip=g)
        # inactive duplicate so widgets don't blank on unfocused windows
        if status in ('normal', 'focused', 'pressed', 'toggled'):
            framed(base, status + '-inactive', fill, frame, raised, grip=g)

# checkbox: recessed white box, check when checked
def cb(checked):
    def d(ox, oy, s):
        r = [f'<rect x="{ox+1}" y="{oy+1}" width="{s-2}" height="{s-2}" fill="#ffffff" stroke="#1a1a1a" stroke-width="1"/>',
             f'<rect x="{ox+2}" y="{oy+2}" width="{s-4}" height="1" fill="#868c93"/>',
             f'<rect x="{ox+2}" y="{oy+2}" width="1" height="{s-4}" fill="#868c93"/>']
        if checked:
            r.append(f'<path d="M{ox+3.5} {oy+s/2} L{ox+s*0.45} {oy+s-4} L{ox+s-3} {oy+3.5}" fill="none" stroke="#4a7a3a" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>')
        return ''.join(r)
    return d
def rb(checked):
    def d(ox, oy, s):
        cx, cy, rr = ox + s / 2, oy + s / 2, s / 2 - 1
        r = [f'<circle cx="{cx}" cy="{cy}" r="{rr}" fill="#ffffff" stroke="#1a1a1a" stroke-width="1"/>',
             f'<path d="M{cx-rr*0.7} {cy-rr*0.7} A {rr} {rr} 0 0 1 {cx+rr*0.7} {cy-rr*0.7}" fill="none" stroke="#868c93" stroke-width="1"/>']
        if checked:
            r.append(f'<circle cx="{cx}" cy="{cy}" r="{rr*0.5}" fill="#2c2a60"/>')
        return ''.join(r)
    return d
for st in ('normal', 'focused', 'pressed', 'disabled', 'normal-inactive'):
    indicator('checkbox', 'checked-' + st, cb(True), 16)
    indicator('checkbox', 'unchecked-' + st, cb(False), 16)
    indicator('radio', 'checked-' + st, rb(True), 16)
    indicator('radio', 'unchecked-' + st, rb(False), 16)

# arrow indicators (scrollbars, spin boxes, combos, menus) — solid NeXT triangles
def arrow(direction, col):
    def d(ox, oy, s):
        m = 4
        pts = {
            'up':    [(ox+s/2, oy+m), (ox+m, oy+s-m), (ox+s-m, oy+s-m)],
            'down':  [(ox+m, oy+m), (ox+s-m, oy+m), (ox+s/2, oy+s-m)],
            'left':  [(ox+s-m, oy+m), (ox+s-m, oy+s-m), (ox+m, oy+s/2)],
            'right': [(ox+m, oy+m), (ox+m, oy+s-m), (ox+s-m, oy+s/2)],
        }[direction]
        p = ' '.join(f'{x:.1f},{y:.1f}' for x, y in pts)
        return f'<polygon points="{p}" fill="{col}"/>'
    return d
ARROW_COL = {'normal': '#1a1a1a', 'focused': '#1a1a1a', 'pressed': '#1a1a1a',
             'disabled': '#8a8a8a', 'normal-inactive': '#4a4a4a'}
for d in ('up', 'down', 'left', 'right'):
    for st, col in ARROW_COL.items():
        indicator('arrow-' + d, st, arrow(d, col), 16)

DEFS = ('<defs>'
        '<linearGradient id="prog" x1="0" y1="0" x2="0" y2="1">'
        '<stop offset="0" stop-color="#b9b6ec"/><stop offset="0.12" stop-color="#dad7f7"/>'
        '<stop offset="0.5" stop-color="#5f5cae"/><stop offset="0.54" stop-color="#5350a2"/>'
        '<stop offset="0.9" stop-color="#3e3b82"/><stop offset="1" stop-color="#2c2a60"/></linearGradient>'
        '<linearGradient id="mgroove" x1="0" y1="0" x2="0" y2="1">'
        '<stop offset="0" stop-color="#8a95a1"/><stop offset="0.18" stop-color="#c4ced8"/>'
        '<stop offset="0.55" stop-color="#a6b0ba"/><stop offset="1" stop-color="#b8c2cc"/></linearGradient>'
        '</defs>')

svg = ('<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n'
       f'<svg xmlns="http://www.w3.org/2000/svg" width="80" height="{_y[0]+8}" viewBox="0 0 80 {_y[0]+8}">\n  '
       + DEFS + '\n  ' + '\n  '.join(els) + '\n</svg>\n')
os.makedirs(OUT, exist_ok=True)
open(os.path.join(OUT, 'SquirrelLevel.svg'), 'w').write(svg)
print(f"generated Kvantum SVG with {len(els)} elements")
