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

========== 
Another good example inspired by ericwen229 from http://community.schemewiki.org/?sicp-ex-4.71:

(not (married ?y ?mary))
; this will terminate correctly with delayed argument!
; And with delay we need only evaluate what's NECESSARRY in filters.