(load "common.scm")

(define (product term a next b)
    (if (> a b) 
        1.0
        (* (term a) (product term (next a) next b))))

(define (product2 term a next b)
    (define (iter a result)
        (if (> a b) 
            result
            (iter (next a) (* (term a) result))))
    (iter a 1.0))


(define (wallis-product n product)
    (define (wallis-term k)
        (/ (* (* 2 k) (+ (* 2 k) 2)) (square (+ (* 2 k) 1))))
    (product wallis-term 1 inc n))

(* 4 (wallis-product 10000 product))
(* 4 (wallis-product 10000 product2))
