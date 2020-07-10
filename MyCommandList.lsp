;#########################################################
;AutoLisp Commands
;ここの以下で読み込みたい.lspファイルを指定する
;各.lsoファイルはこのファイルのカレントディレクトリにある500_LSPFiles
;以下においておく。
;なお、ACAD側のオプションで、サポートファイルのパスにこの500_LSPFilesまでのパスが必要
;###########################################################
(load "MyLispLib.lsp")
(load "QuickMirror.lsp")
(load "TextHight.lsp")
(load "JustifyBlockBasePoint.lsp")
(load "BGColorChange.lsp")
(load "NewLayer.lsp")
(load "HoleSide.lsp")
(load "HoleTop.lsp")
(load "MDTapSide.lsp")
(load "MDTapTop.lsp")
(load "SlotTop.lsp")




;;---------------------------------------------
; 実験用にいろいろ使える一時コマンド
;-----------------------------------------------
(defun c:temp1 ( / ss test )
;(setq test (entget (car (entsel))))
(setq ss (ssget))
(command "chprop"
ss
""
"lt"
"ByBlock"
"lw"
"ByBlock"
""
)
(princ)
)
