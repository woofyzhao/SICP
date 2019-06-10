(define (product term a next b)
    (if (> a b) 
        1
        (* (term a) (product term (next a) next b))))

(define (product2 term a next b)
    (define (iter a result)
        (if (> a b) 
            result
            (iter (next a) (* (term a) result))))
    (iter a 1))


(define (wallis-product n product)
    (define (wallis-term k)
        (/ (* (* 2 k) (+ (* 2 k) 2)) (square (+ (* 2 k) 1))))
    (define (next k) 
        (+ k 1.0))
    (product wallis-term 1 next n))

(* 4 (wallis-product 100000 product))
(* 4 (wallis-product 100000 product2))
