;ブロック貼り付け+ブロック名変更
(defun c:VB ( / n1 )
(princ "\nブロック貼り付け+ブロック名変更")
	(princ "\n挿入点を指定:")
	(command "pasteblock" pause)
	(setq n1 (cdr (assoc 2(entget (entlast)))))
	(command "rename" "b" n1 )
)
