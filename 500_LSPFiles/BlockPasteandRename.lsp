;�u���b�N�\��t��+�u���b�N���ύX
(defun c:VB ( / n1 )
(princ "\n�u���b�N�\��t��+�u���b�N���ύX")
	(princ "\n�}���_���w��:")
	(command "pasteblock" pause)
	(setq n1 (cdr (assoc 2(entget (entlast)))))
	(command "rename" "b" n1 )
)
