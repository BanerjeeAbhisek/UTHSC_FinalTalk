# UTHSC Quarto reveal.js Template

University of Tennessee Health Science Center theme. Palette:

| Role                         | Color                 | Hex       |
|------------------------------|-----------------------|-----------|
| Bright accent (links, bars)  | Tennessee Orange      | `#E78824` |
| Headings / text on white     | Dark Orange           | `#C14C23` |
| Secondary accent             | Health Sciences Green | `#4D701F` |

Font: **Montserrat** (UTHSC's recommended open-source brand font, via Google Fonts).

## Design
- Title & closing slides: the watercolor **building** as a full-bleed hero (edges faded),
  with the centered UTHS logo top-left.
- Content slides: the same building as a faint, side-faded backdrop.
- The **College of Medicine seal** sits in the bottom-right corner of every slide.
- The official horizontal UTHS logo anchors the footer on every slide.

## Files
- `Template_Practice.qmd` — the presentation (edit content here)
- `custom.scss` — theme (colors, headings, boxes, footer, seal, title)
- `styles.css` — building backdrop + title-slide logo + backdrop opacity
- `assets/uthsc-building-faded.png` — building, edges faded to transparent
- `assets/uthsc-seal.png` — College of Medicine seal (circular, transparent)
- `assets/uthsc-logo-horizontal.png` — footer logo
- `assets/uthsc-logo-centered.png` — title-slide logo

## Render
```bash
quarto render Template_Practice.qmd
```

## Easy tweaks
- Backdrop strength: `opacity` in the first block of `styles.css` (now `0.14`).
- Seal size / position: `.uthsc-seal-badge img { width }` and `.uthsc-seal-badge { right/bottom }` in `custom.scss`.
- Title-slide logo size / position: `#title-slide` block at the bottom of `styles.css`.
- Footer text: the `.uthsc-right` div in the `.qmd` `include-after-body` block.
- Callout boxes: `uthsc-orange-box`, `uthsc-green-box`, `uthsc-code-box`.

## Logos
These are the official UTHS print logos with the black background removed so they sit on
white slides. The seal was cropped to a clean circle. If you ever need vector/EPS versions,
download them from https://uthsc.edu/brand/logos/ and replace the PNGs (keep the filenames).
