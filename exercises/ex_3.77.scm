(load "common.scm")

(define (integral integrand initial-value dt)
    (cons-stream initial-value
                 (if (stream-null? integrand)
                     the-empty-stream
                     (integral (stream-cdr integrand)
                               (+ (* dt (stream-car integrand))
                                  initial-value)
                               dt))))

(define (integral delayed-integrand initial-value dt)
    (cons-stream initial-value
                 (let ((integrand (force delayed-integrand)))
                    (if (stream-null? integrand)
                        the-empty-stream
                        (integral (delay (stream-cdr integrand))
                                  (+ (* dt (stream-car integrand))
                                     initial-value)
                                  dt)))))

(define (solve f y0 dt)
    (define y (integral (delay dy) y0 dt))
    (define dy (stream-map f y))
    y)

;f(x) = 10e^x
(stream-ref (solve (lambda (x) x) 10 0.0001) 10000)