;;;------------------------------------
; 穴の側面を自動で書くプログラム
; hs
; (Hole Side)
; 200610
; YasAct
; Requirements:med ON OFF
;---------------------------------
(defun C:hs () 
  (OFF)
  ;ユーザからの入力
  (setq dia (getreal "\n穴の径を入力 : "))
  (setq depth (getreal "\n穴の深さを入力 : "))
  (setq pc (getpoint "\n挿入位置を指定 : "))

  ;---描画中心点pcを2軸(X,Y)に分解
  (setq pcx (car pc)) ;挿入位置のx座標
  (setq pcy (cadr pc)) ;挿入位置のy座標

  ; LINEを引くための座標定義--------------------------------------------------
  ; <点の説明>
  ; p1:右側の穴線(p1s -> p1e のLINE)
  ; p2:左側の穴線(p2s -> p2e のLINE)
  ; pc:CenterLine(pcs -> pce のLINE)
  ; 2つの値から座標作るにはlistしないとだめ。'()で並べてもconsで作ってもダメ
  ; p1,p2の座標定義-----------------------------
  (setq p1s (list (+ pcx (/ dia 2)) pcy))
  (setq p1e (list (+ pcx (/ dia 2)) (- pcy depth)))

  (setq p2s (list (- pcx (/ dia 2)) pcy))
  (setq p2e (list (- pcx (/ dia 2)) (- pcy depth)))

  ; pcの座標定義------------------------------
  (setq pcs (list pcx (+ pcy (* depth 0.2))))
  (setq pce (list pcx (- pcy (* depth 1.2))))
  ;;座標定義ここまで------------------------------------------------

  ;; SelectionSetの初期化-----------------
  (setq ss (ssadd)) ;全部用SelectionSet(BlockPastした後にERASEするため)
  (setq ssh (ssadd)) ;穴線用のSelectionSet
  (setq ssc (ssadd)) ;CenterLine用のSelectionSet
  ;;--------------------------------------

  ;;線を引く------------------------------------------------------------
  ;;CenterLineの右側の穴線描画
  (command "_line" p1s p1e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssh (ssadd (entlast) ssh))
  ;;CenterLineの左側の穴線描画
  (command "_line" p2s p2e "")
  (setq ss (ssadd (entlast) ss))
  (setq ssh (ssadd (entlast) ssh))

  ;;--------------------------------------------------------
  ;;---------CenterLineを描画------------------
  (command "_line" pcs pce "")
  (setq ss (ssadd (entlast) ss))
  (setq ssc (ssadd (entlast) ssc))

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


  ;---------------------------------------------
  ; 現在のEntity(SelectionSet:ssに対して)のchprop
  (command "_chprop" ss "")
  (command "c" "ByBlock" "lt" "ByBlock" "lw" "ByBlock" "pl" "ByBlock" "")

  ;; CenterLine(SelectionSet:sscに対して)のchprop
  (command "_chprop" ssc "")
  (command "c" "ByBlock" "lt" "center" "lw" "0.05" "pl" "ByBlock" "")
  (setq ss1 nil) ;線種とか処理用のSelectionSetを初期化

  ;;--------Block化------
  (command "_COPYBASE" pc ss "") ;基点コピー
  (command ".ERASE" ss "") ;元の図形を消しちゃう
  (command "_PASTEBLOCK" pc) ;ブロックでペースト

  ;;使用したSelectionSetをnilで初期化する(メモリ解放になるらしい)
  (setq ss nil)
  (setq ssh nil)
  (setq ssc nil)
  
  (princ)
  (ON)
)