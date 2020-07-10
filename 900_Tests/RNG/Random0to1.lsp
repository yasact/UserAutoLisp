;;;  Random0to1.LSP [command name: R01]
;;;  Generates "random" six-decimal-place number between 0 and 1
;;;  Would be random enough for single calls this way:
;;;    (defun C:R01 ()
;;;      (/ (atof (substr (rtos (rem (getvar 'date) 1) 2 16) 13)) 1000000)
;;;    ); end defun
;;;  but for multiple calls that might be very close together, the first
;;;  digit(s) of those results could be repeats.  This version moves the
;;;  last digit, which changes the fastest, to just after the decimal point.
;;;  Kent Cooper, September 2008
;
(defun C:R01 (/ digits)
  (setq digits (substr (rtos (rem (getvar 'date) 1) 2 16) 13))
  (atof (strcat "0." (substr digits 6) (substr digits 1 5)))
;  (princ digits)
); end defun
