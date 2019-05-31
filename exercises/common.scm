(define (even? n)
    (= (remainder n 2) 0))

(define (divides? a b)
    (= (remainder b a) 0))

(define (double a)
    (+ a a))

(define (half a)
    (/ a 2))

(define (sum-of-square x y) (+ (square x) (square y)))