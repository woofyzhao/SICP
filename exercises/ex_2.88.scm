(define (install-polynomial-package)
    (define (negative p)
        (make-polynomial (variable p) (negative-terms (term-list p))))
    (define (negative-terms term-list)
        (map (lambda (term)
                (make-term (order term)
                           (negative (coeff term)))) ; generic negative dispatch on coeff
             term-list))
    (define (sub-poly p1 p2)
        (add p1 (negative p2)))

    (put 'negative '(polynomial) negative)
    (put 'sub '(polynomial polynomial) sub-poly))