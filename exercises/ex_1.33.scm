(load "prime.scm")

(define (filtered-accumulate_0 combiner filter null-value term a next b)
    (define (iter a result)
        (cond ((> a b) result)
              ((filter a) (iter (next a) (combiner (term a) result)))
              (else (iter (next a) result))))
    (iter a null-value))

; another approach
; always true (unit rule): (= x (combiner null-value x))
(define (filtered-accumulate combiner filter null-value term a next b)
    (define (iter a result)
        (if (> a b) 
            result
            (iter (next a) 
                  (combiner (if (filter a)
                                (term a)
                                null-value) result))))
    (iter a null-value))


(define (squared-prime-sum a b)
    (filtered-accumulate + prime? 0 square a inc b))

(define (product-of-prime-to n)
    (filtered-accumulate * (lambda (x) (= (gcd x n) 1)) 1 identity 1 inc (- n 1)))

(squared-prime-sum 1 10) ;should be 87
(product-of-prime-to 10) ;should be 189
(product-of-prime-to 15) ;should be 896896