(define (contains-circle? x)
    (define seen '())
    (define (check p)
        (cond ((null? p) #f)
              ((memq p seen) #t)
              (else
                (set! seen (cons p seen))
                (check (cdr p)))))
    (check x))


(define x (list 1 2))
(contains-circle? x)

(define y (cons 3 (cons 4 x)))
(set-cdr! (cdr x) x)
(contains-circle? x)
(contains-circle? y)
    