(load "common.scm")

(define (element-of-set? x set)
    (cond ((null? set) false)
          ((equals? x (car set)) true)
          (else (element-of-set? x (car set)))))

(define (adjoin-set x set)
    (cons x set))

(define (union-set set1 set2)
    (append set1 set2))

(define (intersection-set set1 set2)
    (accumulate (lambda (x res)
                    (if (element-of-set? x set2)
                        (adjoin-set x res)
                        res))
                nil
                set1))

; Peference application: lots of adjoin or union, limited duplicates situation.
