(load "sum.scm")

(define (accumulate_0 combiner null-value term a next b)
    (if (> a b)
        null-value
        (combiner (term a) (accumulate_0 combiner null-value term (next a) next b))))

(define (accumulate combiner null-value term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) (combiner (term a) result))))
    (iter a null-value))

(define (sum_0 term a next b)
    (accumulate_0 + 0 term a next b))

(define (product_0 term a next b)
    (accumulate_0 * 1 term a next b))
    
(define (sum term a next b)
    (accumulate + 0 term a next b))

(define (product term a next b)
    (accumulate * 1 term a next b))

(sum_0 square
       1
       inc
       5)

(sum square
     1
     inc
     5)

(product_0 identity 
       1
       inc
       10)

(product identity 
     1
     inc
     10)
