;########################################################
; NewLayer
; コマンド:nl
;####################################
; ユーザから入力された名前の画層を作成し、
; 色は自動で変更
; コマンド抜けるときに現在画層を新規作成した画層にする
;#########################################
;#####################################################
; # メモ
; - lispには乱数生成のコマンドがないので、以下の疑似乱数生成部分を自作
; - 画層色のランダム指示の方法
;   - 本当はHSL空間でL(Lightness)の値がある閾値以上だけにしたいけど(背景黒なので暗い色は見えないので)
;     AutoCADではRGBしか指定できなかったので仕方なく R, G, Bの各々の値を合計して閾値以上とする。(結局この閾値が試行錯誤)
;###################################################
;疑似乱数生成部分
;https://forums.autodesk.com/t5/visual-lisp-autolisp-and-general/lisp-random-number-generator/m-p/2612135/highlight/true#M285387
(setq z 362436069
      w 521288629
)

(defun znew (/) 
  (lsh (setq z (+ (* 36969 (logand z 65535)) (lsh z -16))) 16)
)

(defun wnew (/) 
  (logand (setq w (+ (* 18000 (logand w 65535)) (lsh w -16))) 65535)
)

(defun MWC (/) 
  (+ (znew) (wnew))
)

(defun rnd (/) 
  (setq digit (itoa (/ (MWC) 10000)))
  (atof (strcat "0." (substr digit 6) (substr digit 1 5)))
)

;####################################################
(defun c:nl (/ name r r_s g g_s b b_s sum th) 
  (setq name (getstring "新しい画層の名前を入力"))
  (setq th 375)
  (setq sum 1)
  (while (< sum th) 
    (setq test (rnd))
    (setq r (fix (* (rnd) 255))) ;;rにランダムな数字を代入0～255
    ;(princ r)
    (setq g (fix (* (rnd) 255))) ;;gにランダムな数字を代入0～255
    ;  (princ g)
    (setq b (fix (* (rnd) 255))) ;;bにランダムな数字を代入0～255
    ;  (princ b)
    (setq sum (+ r g b)) ;; 上で生成したrgbの値を合計
  )
  ;(princ sum)
  (setq r_s (rtos r))
  (setq g_s (rtos g))
  (setq b_s (rtos b))
  (setq rgb (strcat r_s "," g_s "," b_s))
  (princ rgb)
  (command "layer" "n" name "c" "t" rgb name "s" name "")
  (princ)
)