;####################################
; 背景色を変更する
; Change BackGround Color of Model space
; Auther:YasAct
; cf.)
; https://www.cadforum.cz/cadforum_en/qaID.asp?tip=3088
; 
; command:bgw -> 背景を白に(make BackGround color white)
; command:bgb -> 背景を黒に(make BackGround color Black)
; command:bgg -> 背景を灰色に(make BackGround color Grey)
; #########################################
; ##################
; # メモ(memo:How does it work)
; ## Japanese
; setenv で環境変数 "Background"の値を変更する。
; 変更した後、ウィンドウを再起動(?)しなきゃいけないので、ペーパー空間に一度行って(tilemode=1)、
; モデル空間に戻る(tilemode=0)ことで対応した
; 
; ## English
; Change environmental value "Background" using "setenv"
; After that, goto Paper Space(tilemode=1) and back to Model Space(tilemod=0), because window must be "Reactivate(?)"
;

; なお、色の指定については : Note (How to assign colors)
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