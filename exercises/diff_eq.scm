(load "common.scm")

(define (integral delayed-integrand initial-value dt)
    (define int
        (cons-stream initial-value
                     (add-stream (scale-stream (force delayed-integrand) dt)
                                 int)))
    int)

(define (solve f y0 dt)
    (define y (integral (delay dy) y0 dt))
    (define dy (stream-map f y))
    y)

;f(x) = 10e^x
(stream-ref (solve (lambda (x) x) 10 0.0001) 10000)

;f(x) = (10 + e^x)
(stream-ref (solve (lambda (x) (- x 10)) 11 0.0001) 10000)
