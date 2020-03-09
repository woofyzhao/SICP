(define (foo op x y)
    (if (not (= y 0))
        (op x y)
        x))


(define (go x y)
    (foo (if (< (/ x y) 0.1) / *) x y))

(go 3 300)
(go 3 20)
(go 11 0)
(go 888 0)