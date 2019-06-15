(load "common.scm")

(define (repeated f n)
    (if (= n 1)
        f
        (compose f (repeated f (- n 1)))))

((repeated inc 100) 99)
((repeated square 2) 5)