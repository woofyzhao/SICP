(load "sum.scm")

(define (sum term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (+ (term a) result))))
    (iter a 0))

(integral cube 0 1.0 0.01)
(integral cube 0 1.0 0.001)