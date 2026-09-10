;; draw-scalebar.lsp - Draw a simple segmented scale bar
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
