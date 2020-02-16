(load "common.scm")

(define random-init 0)

(define random-numbers
    (cons-stream random-init
                 (stream-map rand-update random-numbers)))

(define (monte-carlo experiment-stream passed failed)
    (define (next passed failed)
        (cons-stream (/ passed (+ passed failed))
                     (monte-carlo (stream-cdr experiment-stream) passed failed)))
    (if (stream-car experiment-stream)
        (next (+ passed 1) failed)
        (next passed (+ failed 1))))