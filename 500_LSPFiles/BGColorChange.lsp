;####################################
; 背景色を変更する
; https://www.cadforum.cz/cadforum_en/qaID.asp?tip=3088
; bgw -> 背景を白に
; bgb -> 背景を黒に
; bgg -> 背景を灰色に
; #########################################
; ##################
; # メモ
; setenv で環境変数 "Background"の値を変更する。
; 変更した後、ウィンドウを再起動(?)しなきゃいけないので、ペーパー空間に一度行って(tilemode=1)、
; モデル空間に戻る(tilemode=0)ことで対応した
; なお、色の指定については
; Do not forget to specify the color code as a string and type the variable name verbatim as specified above (upper/lowercase).
; The color code is calculated as:
; (blue * 65536) + (green * 256) + red
; Grey = (173,173,173) -> 11282189
;###################################################
(defun c:bgw()
  (setenv "Background" "16777215")
  (command "tilemode"
  "0"
  )
  (command "tilemode"
  "1"
  )
  (princ)
)

(defun c:bgb()
  (setenv "Background" "0")
  (command "tilemode"
  "0"
  )
  (command "tilemode"
  "1"
  )
  (princ)
)

(defun c:bgg()
  (setenv "Background" "11382189")
  (command "tilemode"
  "0"
  )
  (command "tilemode"
  "1"
  )
  (princ)
)