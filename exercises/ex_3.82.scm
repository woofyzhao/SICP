(load "monte-carlo-stream.scm")

(define (random-in-range low high)
    (cons-stream (+ low (random (- high low))) (random-in-range low high)))
    

(define (estimate-integral P x1 x2 y1 y2)
    (define experiment-stream
        (stream-map P
                    (random-in-range x1 x2) 
                    (random-in-range y1 y2)))
    (scale-stream (monte-carlo experiment-stream 0 0)
                  (* (- y2 y1) (- x2 x1))))

(define (P x y)
    (<= (+ (square (- x 5)) (square (- y 7))) 9))

(define area (estimate-integral P 2.0 8.0 4.0 10.0))
(define pi (scale-stream area (/ 1 9)))

(stream-ref pi 600000)

