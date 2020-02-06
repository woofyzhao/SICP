(load "constraint_prop.scm")

(define (c+ x y)
    (let ((z (make-connector)))
        (adder x y z)
        z))

(define (c* x y)
    (let ((z (make-connector)))
        (multiplier x y z)
        z))

(define (c/ x y)
    (let ((z (make-connector)))
        (multiplier z y x)
        z))

(define (cv x)
    (let ((c (make-connector)))
        (constant x c)
        c))

(define (celsius-fahrenheit-converter x)
    (c+ (c* (c/ (cv 9) (cv 5))
            x)
        (cv 32)))

(define C (make-connector))
(define F (celsius-fahrenheit-converter C))

(probe "Celsius temp" C)
(probe "Fahrenheit temp" F)

(set-value! C 25 'user)

(set-value! F 212 'user)

(forget-value! C 'user)

(set-value! F 212 'user)