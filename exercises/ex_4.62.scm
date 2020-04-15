(rule (last-pair (?x) (?x)))
(rule (last-pair (?x . ?y) ?z)
    (last-pair ?y ?z))

; (last-pair (3) (3))
; (last-pair (1 2 3) (3))
; (last-pair (2 3) (3))
; won't work for (last-pair ?x (3))