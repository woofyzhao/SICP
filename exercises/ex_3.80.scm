(load "common.scm")

(define (integral delayed-integrand initial-value dt)
    (define int
        (cons-stream initial-value
                     (add-stream (scale-stream (force delayed-integrand) dt)
                                 int)))
    int)

(define (RLC R L C dt)
    (lambda (vC0 iL0)
        (define vC (integral (delay dvC) vC0 dt))
        (define iL (integral (delay diL) iL0 dt))
        (define dvC (scale-stream iL (/ -1.0 C)))
        (define diL (add-stream (scale-stream vC (/ 1.0 L))
                                (scale-stream iL (/ (- R) L))))
        (cons vC iL)))

(define circuit (RLC 1 1 0.2 0.1))

(define vi (circuit 10 0))

(to-slice (car vi) 0 100)
(to-slice (cdr vi) 0 100)