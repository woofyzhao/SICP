(define (cons x y)
    (lambda (f) (f x y)))

(define (car x)
    (x (lambda (a b) a)))

(define (cdr x)
    (x (lambda (a b) b)))

(car (cons 45 88))
(cdr (cons 45 88))

; substitution model
(car (cons 45 88))
(car (lambda (f) (f 45 88)))
((lambda (f) (f 45 88)) (lambda (a b) a))
((lambda (a b) a) 45 88)
45
