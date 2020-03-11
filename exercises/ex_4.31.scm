; see evaluator-lazy-optional.scm
; test case:

(load "evaluator-lazy-optional.scm")

(driver-loop)

; input these in the repl loop:
(define count1 0)
(define count2 0)

(define (id-1 x)
    (set! count1 (+ count1 1))
    x)

(define (id-2 x)
    (set! count2 (+ count2 1))
    x)
    
(define (foo a (b lazy) (c lazy) (d lazy-memo))
    (if (> (* b b) 100)
        (+ d d)
        (+ a a c c)))

; case1:
(foo (id-1 3) (id-2 12) (+ (id-1 5) (id-1 6) (/ 10 0)) (id-2 10)) ; 20
count1 ; 1
count2 ; 3

(foo (id-1 3) (id-2 4) (+ (id-1 5) (id-1 6)) (id-2 (/ 10 0))) ; 28
count1 ; 1 + 5 = 6
count2 ; 3 + 2 = 5

(define (foo (op lazy) x y)
    (if (not (= y 0))
        (op x y)
        x))


(define (go x y)
    (foo (if (< (/ x y) 0.1) / *) x y))

(go 3 300)
(go 3 20)
(go 11 0)
(go 888 0)

(define (foo op x y)
    (if (not (= y 0))
        (op x y)
        x))

(go 11 0) ; div by zero