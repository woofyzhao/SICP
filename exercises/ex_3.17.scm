(define (count-pairs x)
    (define seen '())
    (define (count p)
        (cond ((not (pair? p)) 0)
              ((memq p seen) 0)
              (else
               (set! seen (cons p seen))
               (+ 1 (count (car p)) (count (cdr p))))))
    (count x))

; test case from 3.16
(define l3 (cons (cons 1 2) (cons 3 4))) 

(define c (cons 3 4))
(define b (cons 1 c))
(define l4 (cons c b)) 

(define f (cons 6 7))
(define e (cons f f))
(define l7 (cons e e))

(count-pairs l3) ;3
(count-pairs l4) ;3
(count-pairs l7) ;3

(set-cdr! c b)
(count-pairs l4) ;3

