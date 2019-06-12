(load "common.scm")
(load "ex_1.37.scm")

(define (tan-cf x k)
    (cont-frac (lambda (i)
                (if (> i 1) 
                    (- (square x))
                    x))
               (lambda (i) (- (* 2 i) 1))
               k))

(tan-cf 1.0 100)
(tan-cf pi 100)
(tan-cf (/ pi 4) 100)