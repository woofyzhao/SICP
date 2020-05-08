(rule (last-pair (?x) (?x)))
(rule (last-pair (?x . ?y) ?z) (last-pair ?y ?z))

; (last-pair (3) (3))
; (last-pair (1 2 3) (3))
; (last-pair (2 3) (3))
; won't work for (last-pair ?x (3)), probably only emits (last-pair (3) (3))
; Actually it loops forever

==========================================================
However!!! if we reverse the two rules' order above:

(assert! (rule (last-pair (?x . ?y) ?z) (last-pair ?y ?z)))
(assert! (rule (last-pair (?x) (?x))))

The query (last-pair ?x (3)) indeeds generates stuffs:

;;; Query input:
(last-pair ?x (3))

;;; Query results:
(last-pair (3) (3))
(last-pair (?x-2 3) (3))
(last-pair (?x-2 ?x-4 3) (3))
(last-pair (?x-2 ?x-4 ?x-6 3) (3))
(last-pair (?x-2 ?x-4 ?x-6 ?x-8 3) (3))
(last-pair (?x-2 ?x-4 ?x-6 ?x-8 ?x-10 3) (3))
......

Note that the result is an infinite stream, Amazing!

In fact the two rules are both evaluated alternatively and 
the second rule has to be evaluated first in order to generate this result.


