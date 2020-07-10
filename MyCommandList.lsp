;#########################################################
;AutoLisp Commands
;Auther:YasAct
;ここの以下で読み込みたい.lspファイルを指定する
;各.lspファイルはこのファイルのカレントディレクトリにある500_LSPFiles
;以下においておく。
;なお、ACAD側のオプションで、サポートファイルのパスにこの500_LSPFilesまでのパスが必要
;
;Assign .lsp file you want to use below.
;Each .lsp files are located under ./500_LSPFiles.
;Path to ./500_LSPFiles is Needed in Option > SupportFiles in ACAD.exe
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
;TemporaryCommands for Tests, Experiment, and so on
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
