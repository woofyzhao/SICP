(define (install-complex-package)
    (define (project x)
        (make-real (real-part x)))
    (put 'project '(complex) project)
    'done)

(define (install-real-package)
    (define (project x)
        (let ((rat (rationalize (inexact->exact x) 1/100)))
            (make-rational (numerator rat) (denominator rat))))
    (put 'project '(real) project)
    'done)

(define (install-rational-package)
    (define (project x)
        (make-integer (round (/ (numer x) (denom x)))))
    (put 'project '(rational) project)
    'done)

(define (project x)
    (apply-generic 'project x))

(define (drop x)
    (let ((y (project x)))
        (if (equ? (raise y) x)
            (drop y)
            x)))

(define (apply-generic op . args)
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
                (drop (apply proc (map contents args)))
                (if (= (length args) 2)
                    (let ((type1 (car type-tags))
                          (type2 (cadr type-tags))
                          (a1 (car args))
                          (a2 (cadr args)))
                        (cond ((< (level-of type1) (level-of type2)) (apply-generic op (raise a1) a2))
                              ((> (level-of type1) (level-of type2)) (apply-generic op a1 (raise a2)))
                              (else (error "No method for these types " (list op type-tags)))))
                    (error "No method for these types " (list op tppe-tags)))))))


