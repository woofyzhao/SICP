(define (gcd-terms a b)
    (if (empty-termlist? b)
        a
        (gcd-terms b (remainder-terms a b))))

(define (remainder-terms a b)
    (cadr (div-terms a b)))

(define (install-polynomial-package)
    ; internal
    (define (gcd-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1) (gcd-terms (term-list p1) (term-list p2)))
            (error "polys not in same var -- GCD_POLY" (list p1 p2))))
    
    ; interface
    (put 'gcd '(polynomial polynomial) (lambda (a b) (tag (gcd-poly a b)))))

(define (install-scheme-number-package)
    ; internal
    (define (gcd a b)
        (if (= b 0)
            a
            (gcd b (remainder a b))))
    ; interface
    (put 'gcd '(scheme-number scheme-number) gcd))

(define (greatest-common-divisors x y) (apply-generic 'gcd x y))



