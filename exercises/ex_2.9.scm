(load "ch2_interval.scm")

; add: (x-a, x+a) + (y-b, y+b) -> ((x+y)-(a+b), (x+y)+(a+b))
; a,b->a+b
; sub: (x-a, x+a) - (y-b, y+b) -> ((x-y)-(a+b), (x-y)+(a+b))
; a,b->a+b

; mul, a:1 b:3
(print-interval (mul-interval 
                    (make-interval 2 4)
                    (make-interval 1 7)))
; width = 13                  
(print-interval (mul-interval
                    (make-interval 0 2)
                    (make-interval 0 6)))
; width = 6

; div a:0, b:1
(print-interval (div-interval 
                    (make-interval 1 1)
                    (make-interval 3 5)))
; width = 1/15
(print-interval (div-interval 
                    (make-interval 1 1)
                    (make-interval 10 12)))
; width = 1/60