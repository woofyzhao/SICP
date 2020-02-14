(load "common.scm")

(define (partial-sums s)
    (define sums (stream-cons (stream-car s)
                              (add-stream sums (stream-cdr s))))
    sums)

;(define (partial-sums s)
;    (add-stream s
;                (cons-stream 0 (partial-sum s))))

(define (partial-sums s)
    (define sums (add-stream s (cons-stream 0 sums)))
    sums)
