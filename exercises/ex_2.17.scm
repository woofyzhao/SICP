(define (last-pair a)
    (if (= (cdr a) nil)
        a
        (last-pair (cdr a))))

(last-pair (list 1 2 3 4))