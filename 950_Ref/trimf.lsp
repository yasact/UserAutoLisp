(defun c:trimf ( /
  eset
  p1
  p2
  oech
  oos
  oblp
  )
  (setq oech (getvar "cmdecho"))
  (setq oos (getvar "osmode"))
  (setq oblp (getvar "blipmode"))
  (setvar "cmdecho" 0)
  (setvar "osmode" 0)
  (setvar "blipmode" 0)


  (setq fltr '((-4 . "<NOT");;ここよ
                (-4 . "<OR")
                (0 . "INSERT")
                (0 . "ATTDEF")
                (0 . "DIMENSION")
                (0 . "SOLID")
                (0 . "3DSOLID")
                (0 . "3DFACE")
                (0 . "POINT")
                (-4 . "<AND")
                  (0 . "POLYLINE")
                  (-4 . "&") (70 . 80)
                (-4 . "AND>")
                (0 . "TRACE")
                (0 . "SHAPE")
                (-4 . "OR>")
              (-4 . "NOT>")
             )
  )
  (princ "境界エッジを選択：")
(setq eset (ssget fltr))
(if eset
  (progn
    (setq p1 (getpoint "1点目を指示:"))
    (if p1
      (progn
        (initget 32)
        (setq p2 (getpoint p1 "2点目を指示:"))
        (if p2
          (progn
              (command "trim" eset "" "f" p1 p2 "" "")
          );END progn))
          )
      );END progn))
      )
  );END progn))
  (princ "境界が選択されませんでした")
)
(setvar "cmdecho" oech)
(setvar "osmode" oos)
(setvar "blipmode" oblp)
(princ)
)
