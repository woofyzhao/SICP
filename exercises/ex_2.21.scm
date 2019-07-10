(load "common.scm")

(define (square-list-0 items)
    (if (null? items)
        nil
        (cons (square (car items)) (square-list-0 (cdr items)))))

(define (square-list items)
    (map square items))

(square-list-0 (list 1 2 3 4))
(square-list (list 1 2 3 4))
