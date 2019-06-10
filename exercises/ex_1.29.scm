(load "sum.scm")

(define (simpson f a b n)
    (define (simpson-term k)
        (f (+ a (* k (/ (- b a) n)))))
    (define (sum-term k)
        (cond ((or (= k 0) (= k n)) (simpson-term k))
              ((even? k) (* 2 (simpson-term k)))
              (else (* 4 (simpson-term k)))))
    (define (next k) 
        (+ k 1))
    (* (/ (/ (- b a) n) 3) 
       (sum sum-term 0 next n)))

(integral cube 0 1.0 0.01)
(integral cube 0 1.0 0.001)

(simpson cube 0 1.0 100)
(simpson cube 0 1.0 1000)
