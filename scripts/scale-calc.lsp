;; scale-calc.lsp - Work out the plot scale factor
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
