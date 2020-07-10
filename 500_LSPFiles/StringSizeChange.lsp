
;#########################################################
;AutoLisp Commands
;###########################################################
;########################################################
; NewLayer
; �R�}���h:nl
;####################################
; ���[�U������͂��ꂽ���O�̉�w���쐬���A
; �F�͎����ŕύX
; �R�}���h������Ƃ��Ɍ��݉�w��V�K�쐬������w�ɂ���
;#########################################
;#####################################################
; # ����
; - lisp�ɂ͗��������̃R�}���h���Ȃ��̂ŁA�ȉ��̋^��������������������
; - ��w�F�̃����_���w���̕��@
;   - �{����HSL��Ԃ�L(Lightness)�̒l������臒l�ȏゾ���ɂ���������(�w�i���Ȃ̂ňÂ��F�͌����Ȃ��̂�)
;     AutoCAD�ł�RGB�����w��ł��Ȃ������̂Ŏd���Ȃ� R, G, B�̊e�X�̒l�����v����臒l�ȏ�Ƃ���B(���ǂ���臒l�����s����)
;###################################################
;�^��������������
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
  (setq digit (itoa(/ (MWC) 10000)))
  (atof (strcat "0." (substr digit 6) (substr digit 1 5)))
)

;####################################################
(defun c:nl ( / name r r_s g g_s b b_s sum th)
(setq name (getstring "�V������w�̖��O�����"))
(setq th 375)
(setq sum 1)
(while (< sum th)
  (setq test (rnd))
  (setq r (fix (* (rnd) 255)));;r�Ƀ����_���Ȑ�������0�`255
  ;(princ r)
  (setq g (fix (* (rnd) 255))) ;;g�Ƀ����_���Ȑ�������0�`255
  ;  (princ g)
  (setq b (fix (* (rnd) 255))) ;;b�Ƀ����_���Ȑ�������0�`255
  ;  (princ b)
  (setq sum (+ r g b)) ;; ��Ő�������rgb�̒l�����v
  )
;(princ sum)
(setq r_s (rtos r))
(setq g_s (rtos g))
(setq b_s (rtos b))
(setq rgb (strcat r_s "," g_s "," b_s))
(princ rgb)
(command "layer"
"n"
name
"c"
"t"
rgb
name
"s"
name
""
)
(princ)
)
;####################################
; �w�i�F��ύX����
; https://www.cadforum.cz/cadforum_en/qaID.asp?tip=3088
; bgw -> �w�i�𔒂�
; bgb -> �w�i������
; bgg -> �w�i���D�F��
; #########################################
; ##################
; # ����
; setenv �Ŋ��ϐ� "Background"�̒l��ύX����B
; �ύX������A�E�B���h�E���ċN��(?)���Ȃ��Ⴂ���Ȃ��̂ŁA�y�[�p�[��ԂɈ�x�s����(tilemode=1)�A
; ���f����Ԃɖ߂�(tilemode=0)���ƂőΉ�����
; �Ȃ��A�F�̎w��ɂ��Ă�
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
;�u���b�N���ύX
(defun c:BN ( / n1 )
	(princ "\n�u���b�N���ύX")
	(setq n1 (cdr (assoc 2(entget (car (entsel))))))
	(command "rename" "b" n1 )
)
