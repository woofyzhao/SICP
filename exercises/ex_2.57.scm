(load "symbolic_diff.scm")

(define (augend x) 
    (if (null? (cdddr x))
        (caddr x)
        (cons '+ (cddr x))))

(define (multiplicant x)
    (if (null? (cdddr x))
        (caddr x)
        (cons '* (cddr x))))

(deriv '(+ x 3 y x) 'x)
(deriv '(* x y y x) 'x)
(deriv '(* (* x y) (+ x 3) x) 'x)