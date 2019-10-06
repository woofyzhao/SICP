(define (install-rational-package)

    ; a
    (define (reduce-terms n d)
        (let ((g (gcd-terms n d)))
            (let ((nn (car (div-terms (integerized n g) g)))
                  (dd (car (div-terms (integerized d g) g))))
                (let ((common-factor (greatest-integer-divisor nn dd)))
                    (list (div-coeff nn common-factor) (div-coeff dd common-factor))))))

    (define (div-coeff terms c)
        (mul-terms-by-constant terms (/ 1 c)))

    (define (reduce-poly x y)
        (if (same-variable? (variable x) (variable y))
            (let ((reduced-terms (reduce-terms (term-list x) (term-list y))))
                (let ((x-terms (car reduced-terms))
                      (y-terms (cadr reduced-terms)))
                    (list (make-poly (variable x) x-terms)
                          (make-poly (variable y) y-terms))))
            (error "polys not in same var -- REDUCE-POLY" (list x y))))

    ; b
    (define (reduce-integers n d)
        (let ((g (gcd n d)))
            (list (/ n g) (/ d g))))
    
    (put 'reduce '(polynomial polynomial) reduce-poly)
    (put 'reduce '(scheme-number scheme-number) reduce-integers)

    (define (make-rat n d)
        (let ((reduced (reduce n d)))
            (cons (car reduced) (cadr reduced)))))
