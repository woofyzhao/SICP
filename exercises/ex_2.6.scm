(load "common.scm")

(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
    (lambda (f) 
            (lambda (x) (f ((n f) x)))))

(define one (add-1 zero))
(lambda (f) (lambda (x) (f (identity x))))
(lambda (f) (lambda (x) (f x)))

(define two (add-1 one))
(lambda (f) (lambda (x) (f ((one f) x))))
(lambda (f) (lambda (x) (f ((lambda (x) (f x)) x))))
(lambda (f) (lambda (x) (f (f x))))

(define (+ a b)
    (lambda (f)
        (lambda (x) ((a f) ((b f) x)))))

(((+ one two) square) 3)
(((+ two two) inc) 100)
