(load "common.scm")

(define sum 0)

(define (accum x)
    (set! sum (+ x sum))
    sum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))
; sum = 1
(display sum)

(define y (stream-filter even? seq))
; sum = 6
(display sum)

(define z (stream-filter (lambda(x) (= (remainder x 5) 0)) seq))
; sum = 10
(display sum)

(stream-ref y 7)
; 136
; sum = 136
(display sum)

(display-stream z)
; 10, 15, 45, 55, 105, 120, 190, 210
; sum = 210
(display sum)


; without cache:

; sum = 1
; sum = 6
; sum = 15
; sum = 150
; sum = 359
; z: 155, 170, 185, 215, 240, 285, 320
