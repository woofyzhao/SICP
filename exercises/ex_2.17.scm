(define (last-pair s)
    (if (null? (cdr s))
        s
        (last-pair (cdr s))))

(last-pair (list 1 2 3 4 5))