(define (pseudoremainder-terms p q)

    (define (mul-terms-by-constant term-list c)
        (map (lambda (term) (make-term (order term) (mul c (coeff term)))) term-list))

    (define (integerized x y)
        (let ((c (expt (coeff (first-term y)) 
                (+ 1 (order (first-term x)) (- (order (first-term y)))))))
            (mul-terms-by-constat x c)))

    (cadr (div-terms (integerized p q) q)))

(define (gcd-terms a b)
    (if (empty-termlist? b)
        a
        (remove-common-factors (gcd-terms b (pseudoremainder-terms a b)))))


