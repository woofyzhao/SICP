(load "evaluator-logic.scm")

(define (disjoin disjuncts frame-stream)
    (if (empty-disjunction? disjuncts)
        the-empty-stream
        (stream-append-delayed 
            (qeval (first-disjunction disjuncts) frame-stream)
            (delay (disjoin (rest-disjunctions disjuncts)
                            frame-stream)))))

(put 'or 'qeval disjoin)