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

; alternative approach

(define (augend x)
    (accumulate make-sum 0 (cddr x)))

(define (multiplicant x)
    (accumulate make-product 1 (cddr x)))