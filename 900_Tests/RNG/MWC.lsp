(setq z 362436069
      w 521288629
)

(defun znew (/)
	(lsh (setq z (+ (* 36969 (logand z 65535)) (lsh z -16))) 16)
)

(defun wnew (/)
	(logand (setq w (+ (* 18000 (logand w 65535)) (lsh w -16))) 65535)
)

(defun c:MWC (/)
	(+ (znew) (wnew))
)
