;#################################################
; マルチテキストの文字高さを変更&異尺度をなしに
; コマンド：th
;############################################
(defun c:th ( / h1 li l2)
      (setq h1 (getreal"文字の高さを入力:"))
      (setq li (entget (car (entsel))))
      (setq li (subst (cons 40 h1 )(assoc 40 li ) li ))
      ;ここで異尺度プロパティ変更する
      ;ここで方向を水平にする
      (entmod li)
      (command "chprop"
      "A"

      )
      (princ)
)
