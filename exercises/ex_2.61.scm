(define (adjoin-set x set)
    (cond ((or (null? set) (< x (car set))) (cons x set))
          ((= (car set) x) set)
          (else (cons (car set) (adjoin-set x (cdr set))))))