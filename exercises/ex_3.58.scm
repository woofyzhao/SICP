(load "common.scm")

(define (expand num den radix)
    (cons-stream
        (quotient (* num radix) den)
        (expand (remainder (* num radix) den) den radix)))

(to-slice (expand 1 7 10) 0 100)
(to-slice (expand 3 8 10) 0 100)

(to-slice (expand 2 2048 2) 0 100)

; computes the decimal digit stream of num/den in RADIX radix
; num and den are of radix 10