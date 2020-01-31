(define (make-accumulator total)
    (lambda (amount)
        (set! total (+ total amount))
        total))

(define A (make-accumulator 5))

(A 10)

(A 10)
