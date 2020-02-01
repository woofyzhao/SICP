(define (contains-circle? x)
    (define (check fast slow)
        (if (or (null? fast) (null? (cdr fast)))
            #f
            (or (eq? fast slow)
                (check (cdr (cdr fast)) (cdr slow)))))
    (if (null? x)
        #f
        (check (cdr x) x)))

(define x (list 1 2))
(contains-circle? x)

(define y (cons 3 (cons 4 x)))
(set-cdr! (cdr x) x)
(contains-circle? x)
(contains-circle? y)
    