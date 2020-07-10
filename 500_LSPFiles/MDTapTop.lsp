;;;------------------------------------
; タップの上面を自動で書くプログラム
; Metric Diameter Tap Top
; m*tt
; *→3,4,5,6,8,10,12,14,16,18,20,22,24,27,30
; 200610
; YasAct
; Requirements:med ON OFF
;---------------------------------
(defun mdtt (dia pdia th txt) 
  (OFF)
  ;ユーザからの入力
  (setq pc (getpoint "\n挿入位置を指定 : "))
  ;定数定義
  (setq ovs 0.2) ;オーバーシュート割合
  (setq k (+ ovs 0.5)) ;オーバーシュート割合を加味したdiaに対する係数を計算
  (setq kdia (* k dia)) ;kdia = k * dia(あとの計算楽なように)

  ;---描画中心点pcを2軸(X,Y)に分解
  (setq pcx (car pc)) ;挿入位置のx座標
  (setq pcy (cadr pc)) ;挿入位置のy座標


  ; LINEを引くための座標定義--------------------------------------------------
  ; <点の説明>
  ; p1:水平のCenterLine(p1s -> p1e のLINE)
  ; p2:垂直のCenterLine(p2s -> p2e のLINE)
  ; pa:タップ円弧の始点(pax:paのxz座標, pay:paのy座標)
  ; pt:「M*Tap」の文字の位置(ptx:ptのx座標, pty:paのy座標)
  ; 2つの値から座標作るにはlistしないとだめ。'()で並べてもconsで作ってもダメ
  (setq p1s (list pcx (+ pcy kdia)))
  (setq p1e (list pcx (- pcy kdia)))

  (setq p2s (list (- pcx kdia) pcy))
  (setq p2e (list (+ pcx kdia) pcy))

  (setq pax (+ pcx (/ dia 2)))
  (setq pay pcy)
  (setq pa (list pax pay))

  ;Tapの文字の位置
  (setq ptx pcx)
  (setq pty (- pcy (/ dia 4)))
  (setq pt (list ptx pty))

  ;; SelectionSetの初期化-----------------
  (setq ss (ssadd)) ;全部用SelectionSet(BlockPastした後にERASEするため)
  (setq ssr (ssadd)) ;arc(タップ円弧)用SelectionSet
  (setq ssp (ssadd)) ;下穴線(Prepared Line)用のSelectionSet
  (setq ssc (ssadd)) ;CenterLine用のSelectionSet
  (setq sst (ssadd)) ;テキスト用SelectionSet
  ;;--------------------------------------

  ;;線を引く------------------------------------------------------------
  ;;直径pdiaの下穴をpc中心に作図
  (command "_CIRCLE" pc "d" pdia)
  (setq ss (ssadd (entlast) ss))
  (setq ssp (ssadd (entlast) ssp))

  ;;---直径diaのarcをpc中心に作図
  (command "_ARC" "c" pc pa "a" "270")
  (setq ss (ssadd (entlast) ss))
  (setq ssr (ssadd (entlast) ssr)) ;このarcをSlectionSet(ssr)に追加

  ;;--直径diaのarcをpc中心に80°回転
  (command "_ROTATE" ssr (entlast) "" pc "80")

  ;;--CenterLineを描画-----------------
  ;;縦のCenterLineを描画
  (command "_LINE" p1s p1e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))
  ;;横のCenterLineを描画
  (command "_LINE" p2s p2e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))

  ;;文字描画-------------------------------
  ;;M*Tapの文字を入れる
  (command "_TEXT" "j" "m" pc th "0" txt)
  (setq ss (ssadd (entlast) ss))
  (setq sst (ssadd (entlast) sst))

  ;;文字の位置を下げる
  (command "_MOVE" (entlast) "" pc pt)

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
  (setq en (ssname ss 4)) ;ssの4番目の要素の名前を取得
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
  (ON)
)
;;;---mdttの定義ここまで----------------------------

;;;--------各タップサイズ別にコマンドを作る---------------------------------------------------

;;M3----------------------------
(defun c:m3tt () 
  (setq dia 3.0) ;タップ径
  (setq pdia 2.5) ;タップ下穴径
  (setq th 0.25) ;文字サイズ
  (setq txt "M3Tap")
  (mdtt dia pdia th txt)
)

;;M4----------------------------
(defun c:m4tt () 
  (setq dia 4.0) ;タップ径
  (setq pdia 3.3) ;タップ下穴径
  (setq th 0.5) ;文字サイズ
  (setq txt "M4Tap")
  (mdtt dia pdia th txt)
)
;;M5----------------------------
(defun c:m5tt () 
  (setq dia 5.0) ;タップ径
  (setq pdia 4.2) ;タップ下穴径
  (setq th 0.5) ;文字サイズ
  (setq txt "M5Tap")
  (mdtt dia pdia th txt)
)
;;M6----------------------------
(defun c:m6tt () 
  (setq dia 6.0) ;タップ径
  (setq pdia 5.0) ;タップ下穴径
  (setq th 0.5) ;文字サイズ
  (setq txt "M6Tap")
  (mdtt dia pdia th txt)
)
;;M8----------------------------
(defun c:m8tt () 
  (setq dia 8.0) ;タップ径
  (setq pdia 6.8) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M8Tap")
  (mdtt dia pdia th txt)
)
;;M10----------------------------
(defun c:m10tt () 
  (setq dia 10) ;タップ径
  (setq pdia 8.7) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M10Tap")
  (mdtt dia pdia th txt)
)
;;M12----------------------------
(defun c:m12tt () 
  (setq dia 12) ;タップ径
  (setq pdia 10.2) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M12Tap")
  (mdtt dia pdia th txt)
)
;;M14----------------------------
(defun c:m14tt () 
  (setq dia 14) ;タップ径
  (setq pdia 12.0) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M14Tap")
  (mdtt dia pdia th txt)
)

;;M16----------------------------
(defun c:m16tt () 
  (setq dia 16) ;タップ径
  (setq pdia 14.0) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M16Tap")
  (mdtt dia pdia th txt)
)

;;M18----------------------------
(defun c:m18tt () 
  (setq dia 18) ;タップ径
  (setq pdia 15.5) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M18Tap")
  (mdtt dia pdia th txt)
)

;;M20----------------------------
(defun c:m20tt () 
  (setq dia 20) ;タップ径
  (setq pdia 17.5) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M20Tap")
  (mdtt dia pdia th txt)
)

;;M22----------------------------
(defun c:m22tt () 
  (setq dia 22) ;タップ径
  (setq pdia 19.5) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M22Tap")
  (mdtt dia pdia th txt)
)

;;M24----------------------------
(defun c:m24tt () 
  (setq dia 24.0) ;タップ径
  (setq pdia 21.0) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M24Tap")
  (mdtt dia pdia th txt)
)

;;M27----------------------------
(defun c:m27tt () 
  (setq dia 27) ;タップ径
  (setq pdia 24.0) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M27Tap")
  (mdtt dia pdia th txt)
)

;;M30----------------------------
(defun c:m30tt () 
  (setq dia 30) ;タップ径
  (setq pdia 26.5) ;タップ下穴径
  (setq th 1) ;文字サイズ
  (setq txt "M30Tap")
  (mdtt dia pdia th txt)
)