(load "common.scm")

(define (log-of-base x a)
    (if (= (remainder x a) 0)
        (+ 1 (log-of-base (/ x a) a))
        0))

(log-of-base 2 2)
(log-of-base 3 7)
(log-of-base 100 10)
(log-of-base 1000 2)
(log-of-base 10000 5)

(define (cons a b)
    (* (fast-expt 2 a) (fast-expt 3 b)))

(define (car x)
    (log-of-base x 2))

(define (cdr x)
    (log-of-base x 3))

(cons 4 5)
(car (cons 4 5))
(cdr (cons 4 5))