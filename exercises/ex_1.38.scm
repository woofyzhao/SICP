(load "ex_1.37.scm")

(+ 2 (cont-frac (lambda (i) 1.0)
                (lambda (i) 
                    (cond ((= (remainder i 3) 0) 1)
                          ((= (remainder i 3) 1) 1)
                          (else (+ (* 2 (quotient i 3)) 2))))
                100))
            