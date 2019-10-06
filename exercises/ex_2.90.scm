; install different term-list representations correspondingly:
; e.g. dense approach

(define (install-dense-term-list)
    
    ;inner
    (define (adjoin-term term term-list)
        (if (=zero? (coeff term))
            term-list
            (extend-left term-list (order term) (coeff term))))

    (define (first-term term-list) (make-term (- (length term-list) 1) (car term-list)))
    (define (rest-terms term-list) (cdr term-list))

    ;interface
    (define (tag-term term) (attach-tag 'dense-term term))
    (define (tag-list term-list) (attach-tag 'dense-list term-list))
    (put 'adjoin-term '(dense-term dense-list) adjoin-term)
    (put 'first-term '(dense-list) 
        (lambda (term-list) (tag-term (first-term term-list))))
    (put 'rest-term '(dense-list) 
        (lambda (term-list) (tag-list (rest-terms term-list))))
    (put 'make-term 'dense-term 
        (lambda (order coeff) (tag-term (make-term order coeff))))

(define (adjoin-term term term-list) (apply-generic 'adjoin-term term term-list))
(define (first-term term-list) (apply-generic 'first-term term-list))
(define (rest-term term-list) (apply-generic 'rest-term term-list))