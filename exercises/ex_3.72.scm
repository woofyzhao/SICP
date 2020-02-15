(load "ex_3.71.scm")

(define (square-sum pair)
    (+ (square (car pair))
       (square (cadr pair))))

(define items (pairs integers integers square-sum))

(define result (consecutive items 3 square-sum))

(to-slice result 0 20)