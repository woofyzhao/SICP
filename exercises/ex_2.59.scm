(define (union-set set1 set2)
    (cond ((null? set1) set2)
          ((null? set2) set1)
          (else
            (if (element-of-set? (car set1) set2)
                (union-set (cdr set1) set2)
                (cons (car set1) (union-set (cdr set1) set2))))))

; using accumulate
 (define (union-set set1 set2) 
   (accumulate adjoin-set set2 set1)) 