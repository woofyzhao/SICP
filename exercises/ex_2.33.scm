(load "common.scm")

(define (map p seq)
    (accumulate (lambda (x y) (cons (p x) y))
                nil
                seq))

(define (append seq1 seq2)
    (accumulate cons seq2 seq1))

(define (length seq)
    (accumulate (lambda (x y)
                    (if (null? x)
                    y
                    (+ y 1))) 0 seq))