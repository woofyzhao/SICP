(load "common.scm")

(define (double f)
    (lambda (x)
        (f (f x))))

;((double inc) 5)

(((double (double double)) inc) 5); x->x+16