(load "common.scm")

(define tolerance 0.000001)

(define (fixed-point f first-guess)
    (define (try guess)
        (newline)
        (display guess)
        (let ((next (f guess)))
            (if (close-enough? guess next)
                next
                (try next))))
    (try first-guess))

(fixed-point (lambda (x) (/ (log 1000) (log x))) 2.0)

(define (average-damping f)
    (lambda (x) (average x (f x))))

(fixed-point (average-damping (lambda (x) (/ (log 1000) (log x)))) 2.0)