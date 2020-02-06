(load "constraint_prop.scm")

; 2 * c = a + b
(define (average a b c)
    (let ((s (make-connector)) (w (make-connector)))
        (adder a b s)
        (constant 2 w)
        (multiplier w c s)
        'ok))

; c + c = a + b, not working
(define (average-1 a b c)
    (let ((s (make-connector)))
        (adder a b s)
        (adder c c s)
        'ok))

(define a (make-connector))
(define b (make-connector))
(define c (make-connector))
(probe "average" c)
(average a b c)
(set-value! a 2 'user)
(set-value! b 8 'user)