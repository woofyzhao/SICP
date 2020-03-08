; a-recursive
((lambda (n)
    ((lambda (f)
        (f f n))
     (lambda (fib n)
        (if (< n 2)
            n
            (+ (fib fib (- n 1))
               (fib fib (- n 2)))))))
 12)

 ; a-interative
 
 ((lambda (n)
    ((lambda (f)
        (f f 0 1 0))
    (lambda (self a b k)
        (if (= k n)
            a
            (self self b (+ a b) (+ k 1))))))
  12)

; b
(define (f x)
    ((lambda (even? odd?)
        (even? even? odd? x))
     (lambda (ev? od? n)
        (if (= n 0) true (od? ev? od? (- n 1))))
     (lambda (ev? od? n)
        (if (= n 0) false (ev? ev? od? (- n 1))))))
(f 1)
(f 2)
(f 100)
(f 101)