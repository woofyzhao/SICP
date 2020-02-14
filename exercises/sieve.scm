(load "common.scm")


(define (sieve n)
    (cons-stream n
                 (stream-filter (lambda (x) (not (divisible? x n)))
                                (sieve (+ n 1)))))

(define primes (sieve 2))

(map (lambda (n) (stream-ref primes n)) (enumerate-interval 1 100))

(define (sieve s)
    (cons-stream (stream-car s)
                 (sieve (stream-filter (lambda (x) (not (divisible? x (stream-car s))))
                                (stream-cdr s)))))

(define primes (sieve (integers-starting-from 2)))

(map (lambda (n) (stream-ref primes n)) (enumerate-interval 1 100))

