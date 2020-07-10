;;;------------------------------------
; タップの側面を自動で書くプログラム
; Metric Diameter Tap Side
; m*tt
; *→3,4,5,6,8,10,12,14,16,18,20,22,24,27,30
; 200610
; YasAct
; Requirements:med ON OFF
;---------------------------------
(defun mdts (dia pdia th txt) 
  (OFF)
  ;ユーザからの入力
  (setq pc (getpoint "\n挿入位置を指定 : "))
  (setq depth (getreal "\n穴の深さを入力 : "))

  ;---描画中心点pcを2軸(X,Y)に分解
  (setq pcx (car pc)) ;挿入位置のx座標
  (setq pcy (cadr pc)) ;挿入位置のy座標

  ; LINEを引くための座標定義--------------------------------------------------
  ; <点の説明>
  ; p1:右側のタップ線(p1s -> p1e のLINE)
  ; p2:左側のタップ線(p2s -> p2e のLINE)
  ; pp1:右側の(下穴)pdia線(pp1s -> pp1e のLINE)
  ; pp2:左側の(下穴)pdia線(pp2s -> pp2e のLINE)
  ; pc:CenterLine(pcs -> pce のLINE)
  ; 2つの値から座標作るにはlistしないとだめ。'()で並べてもconsで作ってもダメ
  ; p1,p2の座標定義-----------------------------
  (setq p1s (list (+ pcx (/ dia 2)) pcy))
  (setq p1e (list (+ pcx (/ dia 2)) (- pcy depth)))

  (setq p2s (list (- pcx (/ dia 2)) pcy))
  (setq p2e (list (- pcx (/ dia 2)) (- pcy depth)))

  ; pp1,pp2の座標定義------------------------------
  (setq pp1s (list (+ pcx (/ pdia 2)) pcy))
  (setq pp1e (list (+ pcx (/ pdia 2)) (- pcy depth)))

  (setq pp2s (list (- pcx (/ pdia 2)) pcy))
  (setq pp2e (list (- pcx (/ pdia 2)) (- pcy depth)))

  ; pcの座標定義------------------------------
  (setq pcs (list pcx (+ pcy (* depth 0.2))))
  (setq pce (list pcx (- pcy (* depth 1.2))))

  ;Tapの文字の位置
  (setq ptx pcx)
  (setq pty (- pcy (/ dia 4)))
  (setq pt (list ptx pty))
  ;;座標定義ここまで-------------------

  ;; SelectionSetの初期化-----------------
  (setq ss (ssadd)) ;全部用SelectionSet(BlockPastした後にERASEするため)
  (setq ssr (ssadd)) ;タップ径用のSelectionSet
  (setq ssp (ssadd)) ;下穴線(Prepared Line)用のSelectionSet
  (setq ssc (ssadd)) ;CenterLine用のSelectionSet
  (setq sst (ssadd)) ;テキスト用SelectionSet

  ;;線を引く------------------------------------------------------------
  ;;p1,p2線を引く------------------------------------
  ;;CenterLineの右側のタップ径線(p1)描画
  (command "_line" p1s p1e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssr (ssadd (entlast) ssr))

  ;;CenterLineの左側のタップ径線(p2)描画
  (command "_line" p2s p2e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssr (ssadd (entlast) ssr))

  ;;pp1,pp2線を引く------------------------------------
  ;;CenterLineの右側の線(p1)描画
  (command "_line" pp1s pp1e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssp (ssadd (entlast) ssp))

  ;;CenterLineの左側の線(p2)描画
  (command "_line" pp2s pp2e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssp (ssadd (entlast) ssp))

  ;;CenterLineを引く------------------
  (command "_line" pcs pce "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))

  ;;文字描画-------------------------------
  ;;M*Tapの文字を入れる
  (command "_TEXT" "j" "m" pc th "0" txt)
  (setq ss (ssadd (entlast) ss))
  (setq sst (ssadd (entlast) sst))

  ;; 文字の位置を下げる
  (command "_MOVE" (entlast) "" pc pt)

  ;; 各エンティティのプロパティを変える------------------------------------
  ;; 描画した図形の画層を0にする-----------------
  (setq en (ssname ss 0)) ;ssの最初の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)

  (setq en (ssname ss 1)) ;ssの2番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)

  (setq en (ssname ss 2)) ;ssの3番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)

  (setq en (ssname ss 3)) ;ssの4番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)

  (setq en (ssname ss 4)) ;ssの5番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)

  ;---------------------------------------------
  ; 現在のEntity(SelectionSet:ssに対して)のchprop
  (command "_chprop" ss "")
  (command "c" "ByBlock" "lt" "ByBlock" "lw" "ByBlock" "pl" "ByBlock" "")

  ;; CenterLine(SelectionSet:sscに対して)のchprop
  (command "_chprop" ssc "")
  (command "c" "ByBlock" "lt" "center" "lw" "0.05" "pl" "ByBlock" "")

  ;; タップ径(SelectionSet:ssrに対して)のchprop
  (command "_chprop" ssr "")
  (command "c" "ByBlock" "lw" "0.05" "pl" "ByBlock" "")

  ;; 文字「M*Tap」(SelectionSet:sstに対して)のchprop
  (command "_chprop" sst "")
  (command "c" "ByBlock" "lw" "0.05" "pl" "ByBlock" "")

  ;;--------Block化------
  (command "_COPYBASE" pc ss "") ;基点コピー
  (command ".ERASE" ss "") ;元の図形を消しちゃう
  (command "_PASTEBLOCK" pc) ;ブロックでペースト

  ;;使用したSelectionSetをnilで初期化する(メモリ解放になるらしい)
  (setq ss nil)
  (setq ssr nil)
  (setq ssp nil)
  (setq ssc nil)
  (setq sst nil)

  (princ)

  (ON)
)
;;;---mdtsの定義ここまで----------------------------

;;;--------各タップサイズ別にコマンドを作る---------------------------------------------------

;;M3----------------------------
(defun c:m3ts () 
  (setq dia 3.0) ;タップ径
  (setq pdia 2.5) ;タップ下穴径
  (setq th 0.25) ;文字サイズ
  (setq txt "M3Tap")
  (mdts dia pdia th txt)
)

;;M4----------------------------
(defun c:m4ts () 
  (setq dia 4.0) ;タップ径
  (setq pdia 3.3) ;タップ下穴径
  (setq th 0.5) ;文字サイズ
  (setq txt "M4Tap")
  (mdts dia pdia th txt)
)
;;M5----------------------------
(defun c:m5ts () 
  (setq dia 5.0) ;タップ径
  (setq pdia 4.2) ;タップ下穴径
  (setq th 0.5) ;文字サイズ
  (setq txt "M5Tap")
  (mdts dia pdia th txt)
)
;;M6----------------------------
(defun c:m6ts () 
  (setq dia 6.0) ;タップ径
  (setq pdia 5.0) ;タップ下穴径
  (setq th 0.5) ;文字サイズ
  (setq txt "M6Tap")
  (mdts dia pdia th txt)
)
;;M8----------------------------
(defun c:m8ts () 
  (setq dia 8.0) ;タップ径
  (setq pdia 6.8) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M8Tap")
  (mdts dia pdia th txt)
)
;;M10----------------------------
(defun c:m10ts () 
  (setq dia 10) ;タップ径
  (setq pdia 8.7) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M10Tap")
  (mdts dia pdia th txt)
)
;;M12----------------------------
(defun c:m12ts () 
  (setq dia 12) ;タップ径
  (setq pdia 10.2) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M12Tap")
  (mdts dia pdia th txt)
)
;;M14----------------------------
(defun c:m14ts () 
  (setq dia 14) ;タップ径
  (setq pdia 12.0) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M14Tap")
  (mdts dia pdia th txt)
)

;;M16----------------------------
(defun c:m16ts () 
  (setq dia 16) ;タップ径
  (setq pdia 14.0) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M16Tap")
  (mdts dia pdia th txt)
)

;;M18----------------------------
(defun c:m18ts () 
  (setq dia 18) ;タップ径
  (setq pdia 15.5) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M18Tap")
  (mdts dia pdia th txt)
)

;;M20----------------------------
(defun c:m20ts () 
  (setq dia 20) ;タップ径
  (setq pdia 17.5) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M20Tap")
  (mdts dia pdia th txt)
)

;;M22----------------------------
(defun c:m22ts () 
  (setq dia 22) ;タップ径
  (setq pdia 19.5) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M22Tap")
  (mdts dia pdia th txt)
)

;;M24----------------------------
(defun c:m24ts () 
  (setq dia 24.0) ;タップ径
  (setq pdia 21.0) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M24Tap")
  (mdts dia pdia th txt)
)

;;M27----------------------------
(defun c:m27ts () 
  (setq dia 27) ;タップ径
  (setq pdia 24.0) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M27Tap")
  (mdts dia pdia th txt)
)

;;M30----------------------------
(defun c:m30ts () 
  (setq dia 30) ;タップ径
  (setq pdia 26.5) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M30Tap")
  (mdts dia pdia th txt)
)