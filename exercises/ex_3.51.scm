(define (display-line x)
    (display x)
    (newline))

(define (show x)
    (display-line x)
    x)

(show 100)
(show 888)

(define x (stream-map show (stream-enumerate-interval 0 10)))
; 0

(stream-ref x 5)
; 1 2 3 4 5

(stream-ref x 7)
; 6 7