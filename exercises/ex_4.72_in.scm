In order to cope with the situation where one of the stream is infinite 
like the case in 3.5.3.

as an example, to generate all the love and hates:

(load "evaluator-logic.scm")    ; for comparison
(query-driver-loop)             ; for comparison

(load "ex_4.72.scm")
(query-driver-loop)

(assert! (loves kathy kate))
(assert! (loves kate kenny))
(assert! (loves kenny kathy))

(assert! (hates john jason))
(assert! (hates jason jack))
(assert! (hates jack john))

(assert! (rule (loves ?x ?y) (and (loves ?x ?m) (loves ?m ?y))))
(assert! (rule (hates ?x ?y) (and (hates ?x ?m) (hates ?m ?y))))

(or (loves ?x ?y) (hates ?a ?b))