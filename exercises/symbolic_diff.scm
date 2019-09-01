(define (deriv exp var)
    (cond ((number? exp) 0)
          ((variable? exp) (if (same-variable? exp var) 1 0))
          ((sum? exp) (make-sum (deriv (addend exp) var)
                                (deriv (augend exp) var)))
          ((product? exp) (make-sum (make-product (multiplier exp)
                                                  (deriv (multiplicant exp) var))
                                    (make-product (multiplicant exp)
                                                  (deriv (multiplier exp) var))))
          (else
            (error "unknown expression type -- DERIV" exp))))

(define (variable? x) (symbol? x))
(define (same-variable? x y) (and (variable? x) (variable? y) (eq? x y)))

(define (make-sum x y) (list '+ x y))
(define (sum? x) (and (pair? x) (eq? (car x) '+)))
(define (addend x) (cadr x))
(define (augend x) (caddr x))

(define (make-product x y) (list '* x y))
(define (product? x) (and (pair? x) (eq? (car x) '*)))
(define (multiplier x) (cadr x))
(define (multiplicant x) (caddr x))

(deriv '(+ x 3) 'x)
(deriv '(* x y) 'x)
(deriv '(* (* x y) (+ x 3)) 'x)

;simplification on constructors
(define (make-sum x y)
    (cond ((=number? x 0) y)
          ((=number? y 0) x)
          ((and (number? x) (number? y)) (+ x y))
          (else (list '+ x y))))

(define (make-product x y)
    (cond ((or (=number? x 0) (=number? y 0)) 0)
          ((=number? x 1) y)
          ((=number? y 1) x)
          ((and (number? x) (number? y)) (* x y))
          (else (list '* x y))))

(define (=number? exp num)
    (and (number? exp) (= exp num)))

(deriv '(+ x 3) 'x)
(deriv '(* x y) 'x)
(deriv '(* (* x y) (+ x 3)) 'x)

;not good on this
(make-sum (make-sum 'x 3) -1)
(deriv (make-sum (make-sum 'x 3) -1) 'x)
(deriv '(+ (+ x 3) -1) 'x)