(load "sqrt.scm")

(sqrt 1e-16) ; not accurate

;(sqrt 1e80) ; not stop

; a better test
(define (good-enough? guess x)
    (< (abs (/ (- (improve guess x) guess)
               guess)) 
        0.001))

(sqrt 1e-16) 

(sqrt 1e80) 