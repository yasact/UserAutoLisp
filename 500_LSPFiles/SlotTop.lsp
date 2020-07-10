;;;------------------------------------
; スロット(長穴)の上面を自動で書くプログラム
; Slot Top
; 200611
; YasAct
; Requirements:med ON OFF
;---------------------------------
(defun c:slt () 
  (OFF)
  ;ユーザからの入力
  (setq dia (getreal "\n長穴の径を入力 : "))
  (setq l (getreal "\n長穴の長さを入力"))
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
  ; p1:スロットの上側の線(p1s -> p1e のLINE)
  ; p2:スロットの下側の線(p2s -> p2e のLINE)
  ; pch:水平のCenterLine(pchs -> pche のLINE)
  ; pcv:垂直のCenterLine(pcvs -> pcve のLINE)
  ; pcv1:右側の垂直CenterLine(pcv1s -> pcv1e のLINE)
  ; pcv2:左側の垂直CenterLine(pcv2s -> pcv2e のLINE)
  ; 2つの値から座標作るにはlistしないとだめ。'()で並べてもconsで作ってもダメ
  (setq p1s (list (+ pcx (* 0.5 l)) (+ pcy (* 0.5 dia))))
  (setq p1e (list (- pcx (* 0.5 l)) (+ pcy (* 0.5 dia))))

  (setq p2s (list (+ pcx (* 0.5 l)) (- pcy (* 0.5 dia))))
  (setq p2e (list (- pcx (* 0.5 l)) (- pcy (* 0.5 dia))))

  (setq pchs (list (- (- pcx (* 0.5 l)) kdia) pcy))
  (setq pche (list (+ (+ pcx (* 0.5 l)) kdia) pcy))

  (setq pcvs (list pcx (+ pcy kdia)))
  (setq pcve (list pcx (- pcy kdia)))

  (setq pcv1s (list (+ pcx (* 0.5 l)) (+ pcy kdia)))
  (setq pcv1e (list (+ pcx (* 0.5 l)) (- pcy kdia)))

  (setq pcv2s (list (- pcx (* 0.5 l)) (+ pcy kdia)))
  (setq pcv2e (list (- pcx (* 0.5 l)) (- pcy kdia)))

  ; Arcを引くための座標定義--------------------------------------------------
  ; <点の説明>
  ; c1:スロットの右側(+側)のarcの中心(p1s -> p2s の arc)
  ; c2:スロットの左側(-側)のarcの中心(p1e -> p2e の arc)
  (setq c1 (list (+ pcx (* 0.5 l)) pcy))
  (setq c2 (list (- pcx (* 0.5 l)) pcy))

  ;; SelectionSetの初期化-----------------
  (setq ss (ssadd)) ;全部用SelectionSet(BlockPastした後にERASEするため)
  (setq ssc (ssadd)) ;CenterLine用のSelectionSet
  (setq ssl (ssadd)) ;図形線用のSelectionSet
  ;;--------------------------------------

  ; 線を引く------------------------------------------------------------
  ;; 図形線を描画-----------------------------
  ;;; p1:スロットの上側の線(p1s -> p1e のLINE)を作図
  (command "_line" p1s p1e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssl (ssadd (entlast) ssl))

  ;;; p2:スロットの下側の線(p2s -> p2e のLINE)を作図
  (command "_line" p2s p2e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssl (ssadd (entlast) ssl))

  ;;; c1:スロットの右側(+側)のarcの中心(p1s -> p2s の arc)を作図
  (command "_ARC" "c" c1 p2s "a" "180")
  (setq ss (ssadd (entlast) ss))
  (setq ssl (ssadd (entlast) ssl))

  ;;; c2:スロットの右側(+側)のarcの中心(p1s -> p2s の arc)を作図
  (command "_ARC" "c" c2 p1e "a" "180")
  (setq ss (ssadd (entlast) ss))
  (setq ssl (ssadd (entlast) ssl))

  ;; CenterLineを描画-------------------------
  ;;; pch:水平のCenterLine(pchs -> pche のLINE)を作図
  (command "_LINE" pchs pche "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))

  ;;; pcv:垂直のCenterLine(pcvs -> pcve のLINE)を作図
  (command "_LINE" pcvs pcve "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))

  ;;; pcv1:右側の垂直CenterLine(pcv1s -> pcv1e のLINE)を作図
  (command "_LINE" pcv1s pcv1e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))

  ;;; pcv2:左側の垂直CenterLine(pcv2s -> pcv2e のLINE)を作図
  (command "_LINE" pcv2s pcv2e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))

  ; プロパティを変更する---------------------------------------
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
  (setq en (ssname ss 3)) ;ssの3番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)
  (setq en (ssname ss 4)) ;ssの3番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)
  (setq en (ssname ss 5)) ;ssの3番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)
  (setq en (ssname ss 6)) ;ssの3番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)
  (setq en (ssname ss 7)) ;ssの3番目の要素の名前を取得
  (setq ed (entget en))
  (setq ed (med ed 8 "0")) ;画層を0にする
  (entmod ed)
  ;; ---------------------------------------------

  ;; 全部のEntity(SelectionSet:ssに対して)のchprop
  (command "_chprop" ss "")
  (command "c" "ByBlock" "lt" "ByBlock" "lw" "ByBlock" "pl" "ByBlock" "")

  ;; CenterLine(SelectionSet:sscに対して)のchprop
  (command "_chprop" ssc "")
  (command "c" "ByBlock" "lt" "center" "lw" "0.05" "pl" "ByBlock" "")


  ; Block化--------------------------------------------------
  (command "_COPYBASE" pc ss "") ;基点コピー
  (command ".ERASE" ss "") ;元の図形を消しちゃう
  (command "_PASTEBLOCK" pc) ;ブロックでペースト

  ;;使用したSelectionSetをnilで初期化する(メモリ解放になるらしい)
  (setq ss nil)
  (setq ssc nil)
  (setq ssl nil)
  (ON)
)