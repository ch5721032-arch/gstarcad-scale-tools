;; scale-selection.lsp - Scale a selection using a reference length
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
