(load "common.scm")
(define (make-segment p1 p2) (cons p1 p2))
(define (start-segment s) (car s))
(define (end-segment s) (cdr s))
(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))

(define (print-point p)
    (newline)
    (display "(")
    (display (x-point p))
    (display ",")
    (display (y-point p))
    (display ")"))

(define (midpoint-segment s)
    (let ((start (start-segment s))
          (end (end-segment s)))
        (make-point
            (average (x-point start) (x-point end))
            (average (y-point start) (y-point end)))))

(define p1 (make-point 0.0 0.0))
(define p2 (make-point 11.0 22.0))
(define s (make-segment p1 p2))
(print-point (midpoint-segment s))




