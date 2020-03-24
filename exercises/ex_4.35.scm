(define (an-integer-between a b)
    (require (<= a b))
    (amb a (an-integer-between (+ a 1) b)))
        