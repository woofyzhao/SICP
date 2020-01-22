; ugly
;(define (pseudoremainder-terms p q)

;    (define (mul-terms-by-constant term-list c)
;        (map (lambda (term) (make-term (order term) (mul c (coeff term)))) term-list))

;    (define (integerized x y)
;        (let ((c (expt (coeff (first-term y)) 
;                (+ 1 (order (first-term x)) (- (order (first-term y)))))))
;            (mul-terms-by-constat x c)))
;
;    (cadr (div-terms (integerized p q) q)))
;

; incorrect
;(define (gcd-terms a b)
;    (if (empty-termlist? b)
;        a
;        (remove-common-factors (gcd-terms b (pseudoremainder-terms a b)))))

; solution from https://www.inchmeal.io/sicp/ch-2/ex-2.96.html
 (define (gcd-terms a b)
     (if (empty-termlist? b)
         (divide-all-coeffs-by-their-gcd a)
         (gcd-terms b (pseudoremainder-terms a b))
     )
  )

  (define (pseudoremainder-terms p q)
    (let ((o1 (order (first-term p)))
          (o2 (order (first-term q)))
          (c (coeff (first-term q))))
      (let ((factor (expt c (+ 1 (- o1 o2)))))
        (let ((pp (mul-term-by-all-terms (make-term 0 factor) p)))
          (remainder-terms pp q)
        )
      )
    )
  )
  
  (define (remainder-terms a b)
      (cadr (div-terms a b))
  )

  (define (divide-all-coeffs-by-their-gcd terms)
    (define (get-coeffs-list terms)
      (if (empty-termlist? terms)
          '()
          (cons (coeff (first-term terms)) (get-coeffs-list (rest-terms terms)))
      )
    )
    (if (empty-termlist? terms)
        terms
        (let ((all-coeff (get-coeffs-list terms)))
          (let ((gcd-of-all-coeffs (apply gcd all-coeff)))
            (mul-term-by-all-terms (make-term 0 (/ 1 gcd-of-all-coeffs)) terms)
          )
        )
    )
  )
