;;;------------------------------------
; 穴の上面を自動で書くプログラム
; ht
; (Hole Top)
; 200610
; YasAct
; Requirements:med ON OFF
;--------------------------------
(defun c:ht () 
  (OFF)
  ;ユーザからの入力
  (setq dia (getreal "\n穴の径を入力 : "))
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
  ; 2つの値から座標作るにはlistしないとだめ。'()で並べてもconsで作ってもダメ
  (setq p1s (list pcx (+ pcy kdia)))
  (setq p1e (list pcx (- pcy kdia)))

  (setq p2s (list (- pcx kdia) pcy))
  (setq p2e (list (+ pcx kdia) pcy))

  ;; SelectionSetの初期化-----------------
  (setq ss (ssadd)) ;全部用SelectionSet(BlockPastした後にERASEするため)
  (setq ssc (ssadd)) ;CenterLine用のSelectionSet
  ;;--------------------------------------

  ;;線を引く------------------------------------------------------------
  ;;---直径diaの円をpc中心に作図
  (command "_CIRCLE" pc "d" dia)
  (setq ss (ssadd (entlast) ss))

  ;;--CenterLineを描画
  ;;;---縦のCenterLineを描画
  (command "_LINE" p1s p1e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))
  ;;;---横のCenterLineを描画
  (command "_LINE" p2s p2e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))

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
  ;---------------------------------------------

  ; 現在のEntity(SelectionSet:ssに対して)のchprop
  (command "_chprop" ss "")
  (command "c" "ByBlock" "lt" "ByBlock" "lw" "ByBlock" "pl" "ByBlock" "")

  ;; CenterLine(SelectionSet:sscに対して)のchprop
  (command "_chprop" ssc "")
  (command "c" "ByBlock" "lt" "center" "lw" "0.05" "pl" "ByBlock" "")

  ;;--------Block化------
  (command "_COPYBASE" pc ss "") ;基点コピー
  (command ".ERASE" ss "") ;元の図形を消しちゃう
  (command "_PASTEBLOCK" pc) ;ブロックでペースト

  ;;使用したSelectionSetをnilで初期化する(メモリ解放になるらしい)
  (setq ss nil) ;選択セット(SS)を初期化
  (setq ssc nil)

  (ON)
)