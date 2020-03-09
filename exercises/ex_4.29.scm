(define (square x)
    (* x x))

; with memorization

(square (id 10)) ; 100
count ; 1

; without memorization
(square (id 10)) ; 100
count ; 2