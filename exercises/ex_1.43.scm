(load "common.scm")

; recursive
(define (repeated f n)
    (if (= n 0) 
        identity 
        (compose f (repeated f (- n 1)))))

((repeated inc 100) 99)
((repeated square 2) 5)
((repeated square 3) 5)

; iterative (plain loop)
(define (repeated f n)
    (define (iter k result)
        (if (= k 0)
            result
            (iter (- k 1) (compose f result))))
    (iter n identity))

((repeated inc 100) 99)
((repeated square 2) 5)
((repeated square 3) 5)