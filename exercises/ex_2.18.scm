(load "common.scm")

(define (reverse s)
    (define (iter r next)
        (if (null? next)
            r
            (iter (cons (car next) r) (cdr next))))
    (iter nil s))

(reverse (list 1 4 9 16 25))

