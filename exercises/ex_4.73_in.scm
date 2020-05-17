(load "evaluator-logic.scm")    ; for comparison
(query-driver-loop)             ; for comparison

(load "ex_4.73.scm")
(query-driver-loop)

this would results in infinite recursion if stream is infinite

==========
A good example from https://www.inchmeal.io/sicp/ch-4/ex-4.73.html:

(assert! (rule (ones (1 . ?x)) (ones ?x)))
(assert! (rule (twos (2 . ?x)) (twos ?x)))
(assert! (rule (ones (1))))
(assert! (rule (twos (2))))

(and (ones ?x) (twos ?y))