(define (equals? a b)
    (if (and (pair? a) (pair? b))
        (and (equals? (car a) (car b)) (equals? (cdr a) (cdr b)))
        (eq? a b)))

(equals? '(this is a list) '(this is a list))
(equals? '(this is a list) '(this (is a) list))


;ex_2.55
(car ''19728364839)
(car '''19728364839)
'(xx yy '(a '(100) b))
(eq? 100 '100)

; everything is quotable
'(define (equals? a b)
    (if (and (pair? a) (pair? b))
        (and (equals? (car a) (car b)) (equals? (cdr a) (cdr b)))
        (eq? a b)))

