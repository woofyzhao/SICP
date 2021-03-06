; see solution from https://www.inchmeal.io/sicp/ch-2/ex-2.97.html
; still it is not complete correct in that:
; 1. the calculated factor seems to be wrong
; 2. it does not divid the greatest common divisor of all numerator and denominator coeffs

; the original solution, incorrect
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
        (reduce n d))

