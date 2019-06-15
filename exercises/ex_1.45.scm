(load "fixed-point.scm")

(define (nth-func x n)
    (lambda (y) (/ x (expt y (- n 1)))))

(define a 2)

(fixed-point ((repeated average-damp 1) (nth-func a 1)) 1.0) ;1 -> 1
(fixed-point ((repeated average-damp 1) (nth-func a 2)) 1.0) ;2 -> 1
(fixed-point ((repeated average-damp 1) (nth-func a 3)) 1.0) ;3 -> 1
(fixed-point ((repeated average-damp 2) (nth-func a 4)) 1.0) ;4 -> 2
(fixed-point ((repeated average-damp 2) (nth-func a 5)) 1.0) ;5 -> 2
(fixed-point ((repeated average-damp 2) (nth-func a 6)) 1.0) ;6 -> 2
(fixed-point ((repeated average-damp 2) (nth-func a 7)) 1.0) ;7 -> 2

(fixed-point ((repeated average-damp 3) (nth-func a 8)) 1.0) ;8 -> 3
(fixed-point ((repeated average-damp 4) (nth-func a 16)) 1.0) ;16 -> 4
(fixed-point ((repeated average-damp 5) (nth-func a 32)) 1.0) ;32 -> 5
(fixed-point ((repeated average-damp 6) (nth-func a 64)) 1.0) ;64 -> 6
(fixed-point ((repeated average-damp 7) (nth-func a 128)) 1.0) ;128 -> 7

(define (nth-root a n)
    (fixed-point ((repeated average-damp (floor (/ (log n) (log 2)))) 
                  (nth-func a n))
                 1.0))

(nth-root 2 1)
(nth-root 2 2)
(nth-root 2 127)
(nth-root 2 128)
(nth-root 2 129)
(nth-root 100 1000)