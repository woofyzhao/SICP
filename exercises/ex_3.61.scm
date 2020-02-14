(load "ex_3.60.scm")

(define (invert-unit-series S)
    (define X (cons-stream 1
                           (mul-series (negative (stream-cdr s))
                                       X)))
    X)

