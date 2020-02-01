(define (count-pairs x)
    (if (not (pair? x))
        0
        (+ (count-pairs (car x))
           (count-pairs (cdr x))
           1)))

(define l3 (cons (cons 1 2) (cons 3 4))) 

(define c (cons 3 4))
(define b (cons 1 c))
(define l4 (cons c b)) 

(define f (cons 6 7))
(define e (cons f f))
(define l7 (cons e e))

(count-pairs l3) ;3
(count-pairs l4) ;4
(count-pairs l7) ;7

(set-cdr! c b)
(count-pairs l4) ;infinite

