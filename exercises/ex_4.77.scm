(load "evaluator-logic.scm")

(define (append-filter frame f)
    (append frame (list (cons '__filter f))))

(define (filter-frames frame-stream)

    (define (filter frame)
        (if (or (null? frame)
                (not (eq? '__filter (binding-variable (last frame)))))
            (singleton-stream frame)
            ((cdr (last frame)) frame)))

    (stream-flatmap filter frame-stream))

(define (negate operands frame-stream)
    (stream-map
        (lambda (frame)
            (append-filter 
                frame
                (lambda (frame)
                    (if (stream-null? 
                            (qeval (negated-query operands)
                                   (singleton-stream frame)))
                            (singleton-stream frame)
                            the-empty-stream))))
        frame-stream))

(put 'not 'qeval negate)

(define (lisp-value call frame-stream)
    (stream-map
        (lambda (frame)
            (append-filter
                frame
                (lambda (frame)
                    (if (execute
                            (instantiate 
                                call
                                frame
                                (lambda (v f)
                                    (error "Unknown pat var -- LISP-VALUE" v))))
                        (singleton-stream frame)
                        the-empty-stream))))
        frame-stream))

(put 'lisp-value 'qeval lisp-value)

; the following apply the filter to neccessary places

(define (conjoin conjuncts frame-stream)
    (if (empty-conjunction? conjuncts)
        frame-stream
        (filter-frames
            (conjoin (rest-conjunctions conjuncts)
                     (qeval (first-conjunction conjuncts)
                        frame-stream)))))

(put 'and 'qeval conjoin)

(define (disjoin disjuncts frame-stream)
    (if (empty-disjunction? disjuncts)
        the-empty-stream
        (filter-frames
            (interleave-delayed 
                (qeval (first-disjunction disjuncts) frame-stream)
                (delay (disjoin (rest-disjunctions disjuncts)
                                frame-stream))))))

(put 'or 'qeval disjoin)

; (and (supervisor ?x ?y) (not (job ?x (computer programmer))))
; (and (not (job ?x (computer programmer))) (supervisor ?x ?y))


==========
Note: the time to apply the filter above is wrong and doesn't make sense.
In order to perform the filter (promise) as soon as possible, we can do it in 
the extend function once all variables are bound.

See an implementation from https://www.inchmeal.io/sicp/ch-4/ex-4.77.html