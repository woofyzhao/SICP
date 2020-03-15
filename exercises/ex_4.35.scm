(define (an-integer-between a b)
    (if (> a b)
        (amb)
        (amb a (an-integer-between (+ a 1) b))))
        