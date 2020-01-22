(define (install-polynomial-package)
    (define (=zero? p)
        (define (zero-coeff? term-list)
            (or (emtpy-termlist? term-list)
                (and (=zero? (coeff (first-term term-list)))
                     (zero-coeff? (rest-terms term-list)))))
        (zero-coeff? (term-list p)))
        
    (put '=zero? '(polynomial) =zero?))

