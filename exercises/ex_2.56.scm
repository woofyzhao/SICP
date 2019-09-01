(load "symbolic_diff.scm")

(define (make-exponentiation base exp)
    (cond ((=number? exp 0) 1)
          ((=number? exp 1) base)
          ((=number? base 0) 0)
          ((and (number? base) (number? exp)) (expt base exp))
          (else (list '** base exp))))

(define (exponentiation? x) (and (pair? x) (eq? (car x) '**)))
(define (base x) (cadr x))
(define (exponent x) (caddr x))

(define (deriv exp var)
    (cond ((number? exp) 0)
          ((variable? exp) (if (same-variable? exp var) 1 0))
          ((sum? exp) (make-sum (deriv (addend exp) var)
                                (deriv (augend exp) var)))
          ((product? exp) (make-sum (make-product (multiplier exp)
                                                  (deriv (multiplicant exp) var))
                                    (make-product (multiplicant exp)
                                                  (deriv (multiplier exp) var))))
          ((exponentiation? exp) 
           (make-product (make-product (exponent exp) (make-exponentiation 
                                                        (base exp)
                                                        (make-sum (exponent exp) -1)))
                         (deriv (base exp) var)))
          (else
            (error "unknown expression type -- DERIV" exp))))

(deriv '(** (* x y) 0) 'x)
(deriv '(** (* x y) 1) 'x)
(deriv '(+ (* x y) (+ 3 x)) 'x)
(deriv '(** (+ (* x y) (+ 3 x)) 100) 'x)
(deriv '(** (+ (* x 100) (+ 3 x)) 100) 'x)
(deriv '(** (+ (* x y) (+ 3 x)) y) 'x)

;(* (* y 
;      (** (+ (* x y) (+ 3 x)) 
;          (+ y -1)))
;   (+ y 1))