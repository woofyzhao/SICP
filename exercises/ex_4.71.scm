(load "evaluator-logic.scm")

(define (simple-query query-pattern frame-stream)
    (stream-flatmap
        (lambda (frame)
            (stream-append
                (find-assertions query-pattern frame)
                (apply-rules query-pattern frame)))
        frame-stream))

(define (disjoin disjuncts frame-stream)
    (if (empty-disjunction? disjuncts)
        the-empty-stream
        (interleave 
            (qeval (first-disjunction disjuncts) frame-stream)
            (disjoin (rest-disjunctions disjuncts)
                            frame-stream))))

(put 'or 'qeval disjoin)