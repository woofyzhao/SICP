
(load "common.scm")

(define (fib n)
    (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q count)
    (cond ((= count 0) b)
          ((even? count) (fib-iter 
                            a 
                            b 
                            (sum-of-square p q) 
                            (+ (square q) (* 2 (* p q)))
                            (/ count 2)))
          (else           (fib-iter 
                            (+ (* a (+ p q)) (* b q)) 
                            (+ (* a q) (* b p))
                            p
                            q
                            (- count 1)
                            ))))

(fib 0)
(fib 1)
(fib 2)
(fib 3)
(fib 4)
(fib 5)
(fib 6)
(fib 10)
(fib 16)
(fib 27)
(fib 40)
(fib 64)