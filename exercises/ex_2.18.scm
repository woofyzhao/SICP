(define (reverse s)
    (define (iter r next)
        (if (null? next)
            r
            (cons (cdr next) r)))
    (iter nil s))

