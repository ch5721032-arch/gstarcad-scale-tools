# GstarCAD Scale Tools

Plot-scale calculations, a ready-to-place scale bar and reference scaling for accurate sheets.

Works with **GSTARCAD**, AutoCAD, ZWCAD, and BricsCAD.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Contents

- [About](#about)
- [Scripts Overview](#scripts-overview)
- [Quick Start](#quick-start)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## About

Plot scale is the number one question at printing time: how big will this be on paper, and what factor should be used? These tools convert between a 1:n scale and real/paper lengths, draw a segmented scale bar for quick reference, and rescale a selection by a measured reference length.

Everything here is free to use with GstarCAD. Download the latest GstarCAD
release from the [official GstarCAD website](https://www.gstarcad.net). All
scripts are tested with **[GSTARCAD](https://www.gstarcad.net)** and major
DWG-based CAD platforms.

## Scripts Overview

| File | Description |
|------|-------------|
| `scripts/scale-calc.lsp` | ;; scale-calc.lsp - Work out the plot scale factor
;; Command: SCALECALC
;; Usage: enter a scale (1:100) and a real length to get the paper length
(defun c:SCALECALC ( / n real paper )
  (setq n (getreal "\nScale 1:n <100>: "))
  (if (null n) (setq n 100.0))
  (setq real (getreal "\nReal length in drawing units: "))
  (if real
    (progn
      (setq paper (/ real n))
      (princ (strcat "\nAt 1:" (rtos n 2 0) ", " (rtos real 2 2)
                     " units = " (rtos paper 2 2) " paper units."))
      (princ (strcat "\nReciprocal factor: " (rtos (/ 1.0 n) 2 6)))
    )
  )
  (princ)
)
 |
| `scripts/draw-scalebar.lsp` | ;; draw-scalebar.lsp - Draw a simple segmented scale bar
;; Command: SCALEBAR
;; Usage: SCALEBAR -> pick the left end -> segment length -> segment count
(defun c:SCALEBAR ( / pt seg n i x0 y0 h )
  (setq pt (getpoint "\nStart point (left end): "))
  (if pt
    (progn
      (setq seg (getdist pt "\nOne segment length <10>: "))
      (if (null seg) (setq seg 10.0))
      (setq n (getint "\nSegments <5>: "))
      (if (null n) (setq n 5))
      (setq x0 (car pt) y0 (cadr pt) h (* seg 0.4) i 0)
      (repeat n
        (command "_.RECTANG"
                 (list (+ x0 (* i seg)) y0)
                 (list (+ x0 (* (1+ i) seg)) (+ y0 h)))
        (setq i (1+ i))
      )
      (setq i 0)
      (repeat (1+ n)
        (command "_.LINE"
                 (list (+ x0 (* i seg)) y0)
                 (list (+ x0 (* i seg)) (+ y0 (* h 1.4)))
                 "")
        (command "_.TEXT" "_J" "_TC"
                 (list (+ x0 (* i seg)) (+ y0 (* h 1.6)))
                 (* h 0.35) 0
                 (rtos (* i seg) 2 0))
        (setq i (1+ i))
      )
      (princ "\nScale bar drawn.")
    )
  )
  (princ)
)
 |
| `scripts/scale-selection.lsp` | ;; scale-selection.lsp - Scale a selection using a reference length
;; Command: SCALESEL
;; Usage: pick objects, base point, then the old and new lengths
(defun c:SCALESEL ( / ss bp oldl newl f )
  (setq ss (ssget))
  (if ss
    (progn
      (setq bp (getpoint "\nBase point: "))
      (setq oldl (getdist bp "\nReference length (old): "))
      (setq newl (getdist bp "\nDesired length (new): "))
      (if (and oldl newl (/= oldl 0.0))
        (progn
          (setq f (/ newl oldl))
          (command "_.SCALE" ss "" bp f)
          (princ (strcat "\nScaled by " (rtos f 2 6) "."))
        )
      )
    )
  )
  (princ)
)
 |

## Quick Start

1. Download the `.lsp` (or `.lin`) file you need
2. In your CAD software, run `APPLOAD`
3. Load the file and type the matching command name shown in the table above

## Compatibility

Tested on GstarCAD 2026/2027 and similar DWG-based platforms. Scripts use
standard AutoLISP functions only, so they work without extra plugins.

For step-by-step [tutorials and drafting guides](https://www.gstarcad.net/cad/),
visit the GstarCAD learning center. New tips are published regularly on the
[GSTARCAD Blog](https://blog.gstarcad.net).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see the [LICENSE](LICENSE) file.
