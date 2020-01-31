(load "monte-carlo.scm")

(define (random-in-range low high)
    (let ((range (- high low)))
        (+ low (random range))))

(define (estimate-integral P x1 x2 y1 y2 trials)
    (define (rand-x) (random-in-range x1 x2))
    (define (rand-y) (random-in-range y1 y2))
    (define (integral-test) (P (rand-x) (rand-y)))
    (* (monte-carlo trials integral-test) (* (- y2 y1) (- x2 x1))))

(define (p x y)
    (<= (+ (square (- x 5)) (square (- y 7))) 9))

(define area (estimate-integral p 2.0 8.0 4.0 10.0 10000000))

(/ area 9)
