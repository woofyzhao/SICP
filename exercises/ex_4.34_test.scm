(load "ex_4.34.scm")

(driver-loop)

; type in repl:

(define cons-0 cons)
(define car-0 car)
(define cdr-0 cdr)

(define (cons x y)
    (cons-0 'lazy-list (lambda (m) (m x y))))

(define (car z)
    ((cdr-0 z) (lambda (p q) p)))

(define (cdr z)
    ((cdr-0 z) (lambda (p q) q)))


(eval '(define (mycons x y) (cons 'lazy-list (lambda (m) (m x y)))) the-global-environment)

(eval '(define (mycar z) ((cdr z) (lambda (p q) p))) the-global-environment)

(eval '(define (mycdr z) ((cdr z) (lambda (p q) q))) the-global-environment)

(define x (eval '(mycons 1 2) the-global-environment))

(user-print (cdr x))

(user-print (force-it (apply (cdr x) (list '(lambda (p q) p)) the-global-environment)))