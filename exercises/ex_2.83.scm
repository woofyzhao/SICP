(define (install-integer-package)
    (define (raise x)
        (make-rational x 1))
    (put 'raise '(integer) raise))

(define (install-rational-package)
    (define (raise x)
        (make-real (/ (numer x) (demon x))))
    (put 'raise '(rational) raise))

(define (install-real-package)
    (define (raise x)
        (make-complex-from-real-image x 0))
    (put 'raise '(complex) raise))

(define (raise x) (apply-generic 'raise x))

