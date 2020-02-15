(load "common.scm")

(define (integral integrand initial-value dt)
    (define int
        (cons-stream initial-value
                     (add-stream (scale-stream integrand dt)
                                 int)))
    int)

(define (rc-circuit R C dt)
    (define (run-circuit is v0)
        (add-stream (scale-stream is R)
                    (integral (scale-stream is (/ 1.0 C) v0 dt))))
    run-circuit)
