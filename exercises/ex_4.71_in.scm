(load "evaluator-logic.scm")   ; for comparison
(query-driver-loop)            ; for comparison

(load "ex_4.71.scm")
(query-driver-loop)


; case for simple-query
(assert! (not-married woofy kate))
(assert! (married johnny mary))
(assert! (married mickey sophia))
(assert! (married kenny mary))
(assert! (rule (married ?x ?y) (married ?y ?x)))

; this at least works partly for the original, but fails completely for the latter
; however I can't think of a more discriminative senario
(married ?a ?b)

; case for disjoin, similar case
(or (not-married woofy ?x) (married ?y mary))

