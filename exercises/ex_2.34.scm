(load "common.scm")

(define (horner-eval x coefficient-seq)
    (accumulate (lambda (this-coeff higher-terms)
                    (+ (* x higher-terms) this-coeff))
                0
                coefficient-seq))

(= (horner-eval 2 (list 1 3 0 5 0 1)) 79)