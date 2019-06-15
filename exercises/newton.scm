(load "fixed-point.scm")

(define dx 0.000001)

(define (deriv g)
    (lambda (x)
        (/ (- (g (+ x dx)) (g x)) 
           dx)))

;((deriv cube) 5)

(define (newton-transform g)
    (lambda (x)
        (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
    (fixed-point (newton-transform g) guess))

(define (sqrt x)
    (newtons-method (lambda (y) (- (square y) x)) 1.0))

;(sqrt 2)

(define (fixed-point-of-transform g transform guess)
    (fixed-point (transform g) guess))

(define (sqrt x)
    (fixed-point-of-transform (lambda (y) (/ x y)) average-damp 1.0))

;(sqrt 2)

(define (sqrt x)
    (fixed-point-of-transform (lambda (y) (- x (square y))) newton-transform 1.0))

;(sqrt 2)
