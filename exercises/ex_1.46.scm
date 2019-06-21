(load "common.scm")

(define (iterative-improve good-enough? improve)
    (define (iter guess)
        (if (good-enough? guess)
            guess
            (iter (improve guess))))
    iter)

(define (sqrt x)
    ((iterative-improve
        (lambda (guess) (close-enough? (square guess) x))
        (lambda (guess) (average guess (/ x guess)))) 1.0))

(sqrt 2)
(sqrt 100)

(define (fixed-point f guess)
    ((iterative-improve 
        (lambda (guess) (close-enough? guess (f guess)))
        f) guess))

(define (sqrt2 a)
    (fixed-point (average-damp (lambda (x) (/ a x))) 1.0))

(sqrt2 2)
(sqrt2 100)

