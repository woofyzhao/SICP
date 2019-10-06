
(define (adjoin-term term term-list)
    (if (=zero? (coeff term))
        term-list
        (extend-left term-list (order term) (coeff term))))

(define (first-term term-list) (make-term (- (length term-list) 1) (car term-list)))
(define (rest-terms term-list) (cdr term-list))