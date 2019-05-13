(define (a-plus-abs-b a b)
    ((if (> b 0) + -) a b)
)           
; a + |b|

(a-plus-abs-b 10 -100)
(a-plus-abs-b 10 100)